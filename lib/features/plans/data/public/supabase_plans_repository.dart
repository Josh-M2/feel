import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/models/reading_plan.dart';
import '../../domain/repositories/plans_repository.dart';
import '../local/plan_progress_local_snapshot.dart';
import '../local/plan_progress_local_store.dart';
import '../local/shared_prefs_plan_progress_local_store.dart';

class SupabasePlansRepository implements PlansRepository {
  SupabasePlansRepository({
    SupabaseClient? client,
    PlanProgressLocalStore? localStore,
  }) : _client = _resolveClient(client),
       _localStore = localStore ?? SharedPrefsPlanProgressLocalStore();

  final SupabaseClient? _client;
  final PlanProgressLocalStore _localStore;

  static final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  static SupabaseClient? _resolveClient(SupabaseClient? client) {
    if (client != null) {
      return client;
    }

    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  bool get _isConfigured => _client != null;
  String? get _authenticatedUserId => _client?.auth.currentUser?.id;

  @override
  ValueListenable<int> get revisionListenable => _revision;

  @override
  Future<List<ReadingPlan>> getPlans() async {
    final List<_PlanCatalogRow> catalog = await _loadCatalog();
    if (catalog.isEmpty) {
      return const <ReadingPlan>[];
    }

    final Map<String, PlanProgressLocalRecord> localProgress =
        await _loadLocalProgressMap();
    final Map<String, PlanProgressLocalRecord> remoteProgress =
        await _loadRemoteProgressMap();

    await _syncLocalProgressToRemoteIfNeeded(
      catalog: catalog,
      localProgress: localProgress,
      remoteProgress: remoteProgress,
    );

    return catalog
        .map(
          (_PlanCatalogRow row) => row.plan.copyWith(
            progress: _mergeProgress(
              local: localProgress[row.plan.id],
              remote: remoteProgress[row.plan.id],
              durationDays: row.plan.durationDays,
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<ReadingPlan> getPlanById(String? planId) async {
    final List<ReadingPlan> plans = await getPlans();
    if (plans.isEmpty) {
      throw StateError('No plans are available from Supabase.');
    }

    if (planId == null || planId.trim().isEmpty) {
      return plans.first;
    }

    return plans.firstWhere(
      (ReadingPlan plan) => plan.id == planId,
      orElse: () => plans.first,
    );
  }

  @override
  Future<ReadingPlan?> getContinuePlan() async {
    final List<ReadingPlan> plans = await getPlans();
    if (plans.isEmpty) {
      return null;
    }

    final List<ReadingPlan> startedPlans = plans
        .where((ReadingPlan plan) => plan.isStarted)
        .toList(growable: false);
    if (startedPlans.isEmpty) {
      return plans.first;
    }

    final List<ReadingPlan> sorted = List<ReadingPlan>.from(startedPlans)
      ..sort((ReadingPlan a, ReadingPlan b) {
        final DateTime aTime =
            DateTime.tryParse(a.progress.lastOpenedAtIso ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final DateTime bTime =
            DateTime.tryParse(b.progress.lastOpenedAtIso ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
    return sorted.first;
  }

  @override
  Future<PlanDayReadState> openPlanDay({
    required String? planId,
    int? dayNumber,
  }) async {
    final ReadingPlan plan = await getPlanById(planId);
    final int targetDayNumber = _resolveRequestedDayNumber(
      requestedDayNumber: dayNumber,
      plan: plan,
    );

    await _recordPlanDayOpened(plan: plan, dayNumber: targetDayNumber);

    final ReadingPlan refreshedPlan = await getPlanById(plan.id);
    final PlanDay day = refreshedPlan.days.firstWhere(
      (PlanDay item) => item.dayNumber == targetDayNumber,
      orElse: () => refreshedPlan.resolvedCurrentDay,
    );
    final int currentIndex = refreshedPlan.days.indexWhere(
      (PlanDay item) => item.dayNumber == day.dayNumber,
    );

    return PlanDayReadState(
      plan: refreshedPlan,
      day: day,
      previousDay: currentIndex > 0 ? refreshedPlan.days[currentIndex - 1] : null,
      nextDay: currentIndex >= 0 && currentIndex + 1 < refreshedPlan.days.length
          ? refreshedPlan.days[currentIndex + 1]
          : null,
    );
  }

  Future<List<_PlanCatalogRow>> _loadCatalog() async {
    if (!_isConfigured) {
      return const <_PlanCatalogRow>[];
    }

    final List<dynamic> planRows = await _client!
        .from('content_reading_plans')
        .select(
          'id, title, subtitle, category_key, category_label, duration_days, description, why_it_helps, sort_order',
        )
        .eq('is_active', true)
        .order('sort_order', ascending: true);
    if (planRows.isEmpty) {
      return const <_PlanCatalogRow>[];
    }

    final List<dynamic> dayRows = await _client!
        .from('content_reading_plan_days')
        .select(
          'plan_id, day_number, title, focus_line, summary, reflection_prompt, prayer_prompt',
        )
        .order('plan_id', ascending: true)
        .order('day_number', ascending: true);

    final List<dynamic> passageRows = await _client!
        .from('content_reading_plan_day_passages')
        .select(
          'plan_id, day_number, sort_order, reference_label',
        )
        .order('plan_id', ascending: true)
        .order('day_number', ascending: true)
        .order('sort_order', ascending: true);

    final Map<String, List<Map<String, dynamic>>> passagesByDayKey =
        <String, List<Map<String, dynamic>>>{};
    for (final dynamic item in passageRows) {
      final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
      final String key = '${row['plan_id']}:${row['day_number']}';
      passagesByDayKey.putIfAbsent(key, () => <Map<String, dynamic>>[]).add(row);
    }

    final Map<String, List<PlanDay>> daysByPlanId = <String, List<PlanDay>>{};
    for (final dynamic item in dayRows) {
      final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
      final String planId = row['plan_id']?.toString() ?? '';
      final int dayNumber = (row['day_number'] as num?)?.toInt() ?? 1;
      final String dayKey = '$planId:$dayNumber';
      final List<String> refs =
          (passagesByDayKey[dayKey] ?? const <Map<String, dynamic>>[])
              .map((Map<String, dynamic> passage) {
                return passage['reference_label']?.toString() ?? '';
              })
              .where((String value) => value.trim().isNotEmpty)
              .toList(growable: false);

      daysByPlanId.putIfAbsent(planId, () => <PlanDay>[]).add(
        PlanDay(
          dayNumber: dayNumber,
          title: row['title']?.toString() ?? 'Day $dayNumber',
          focusLine: row['focus_line']?.toString() ?? '',
          summary: row['summary']?.toString() ?? '',
          passageRefs: refs,
          reflectionPrompt: row['reflection_prompt']?.toString() ?? '',
          prayerPrompt: row['prayer_prompt']?.toString() ?? '',
        ),
      );
    }

    final List<_PlanCatalogRow> catalog = <_PlanCatalogRow>[];
    for (final dynamic item in planRows) {
      final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
      final String planId = row['id']?.toString() ?? '';
      final List<PlanDay> days = List<PlanDay>.from(daysByPlanId[planId] ?? const <PlanDay>[])
        ..sort((PlanDay a, PlanDay b) => a.dayNumber.compareTo(b.dayNumber));
      if (days.isEmpty) {
        continue;
      }

      catalog.add(
        _PlanCatalogRow(
          sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
          plan: ReadingPlan(
            id: planId,
            title: row['title']?.toString() ?? '',
            subtitle: row['subtitle']?.toString() ?? '',
            categoryLabel: (() {
              final String categoryKey =
                  row['category_key']?.toString().trim() ?? '';
              if (categoryKey.isNotEmpty) {
                return AppConstants.categoryLabelForKey(categoryKey);
              }
              return row['category_label']?.toString() ?? '';
            })(),
            durationDays: (row['duration_days'] as num?)?.toInt() ?? days.length,
            description: row['description']?.toString() ?? '',
            whyItHelps: row['why_it_helps']?.toString() ?? '',
            days: days,
          ),
        ),
      );
    }

    catalog.sort((_PlanCatalogRow a, _PlanCatalogRow b) {
      return a.sortOrder.compareTo(b.sortOrder);
    });
    return catalog;
  }

  Future<Map<String, PlanProgressLocalRecord>> _loadLocalProgressMap() async {
    final PlanProgressLocalSnapshot snapshot = await _localStore.load();
    return <String, PlanProgressLocalRecord>{
      for (final PlanProgressLocalRecord entry in snapshot.entries)
        if (entry.planId.trim().isNotEmpty) entry.planId: entry,
    };
  }

  Future<Map<String, PlanProgressLocalRecord>> _loadRemoteProgressMap() async {
    final String? userId = _authenticatedUserId;
    if (!_isConfigured || userId == null) {
      return const <String, PlanProgressLocalRecord>{};
    }

    try {
      final List<dynamic> rows = await _client!
          .from('user_reading_plan_progress')
          .select(
            'plan_id, current_day_number, completed_day_count, started_at, last_opened_at, completed_at, updated_at',
          )
          .eq('user_id', userId);

      return <String, PlanProgressLocalRecord>{
        for (final dynamic item in rows)
          (item as Map)['plan_id']?.toString() ?? '': _mapRemoteProgressRow(
            Map<String, dynamic>.from(item as Map),
          ),
      }..remove('');
    } catch (_) {
      return const <String, PlanProgressLocalRecord>{};
    }
  }

  PlanProgressLocalRecord _mapRemoteProgressRow(Map<String, dynamic> row) {
    final int currentDayNumber =
        (row['current_day_number'] as num?)?.toInt() ?? 1;
    final int completedDayCount =
        (row['completed_day_count'] as num?)?.toInt() ?? 0;
    final String? completedAtIso = row['completed_at']?.toString();
    return PlanProgressLocalRecord(
      planId: row['plan_id']?.toString() ?? '',
      currentDayNumber: currentDayNumber,
      completedDayCount: completedDayCount,
      isStarted: true,
      isCompleted: completedAtIso != null,
      startedAtIso: row['started_at']?.toString(),
      lastOpenedAtIso: row['last_opened_at']?.toString(),
      completedAtIso: completedAtIso,
      updatedAtIso: row['updated_at']?.toString(),
    );
  }

  ReadingPlanProgress _mergeProgress({
    required PlanProgressLocalRecord? local,
    required PlanProgressLocalRecord? remote,
    required int durationDays,
  }) {
    if (local == null && remote == null) {
      return const ReadingPlanProgress.unstarted();
    }

    final int safeDurationDays = durationDays <= 0 ? 1 : durationDays;
    final int completedDayCount = _clampDayCount(
      <int>[
        local?.completedDayCount ?? 0,
        remote?.completedDayCount ?? 0,
      ].reduce((int a, int b) => a > b ? a : b),
      durationDays: safeDurationDays,
    );
    final bool isCompleted =
        (local?.isCompleted ?? false) ||
        (remote?.isCompleted ?? false) ||
        completedDayCount >= safeDurationDays;

    final PlanProgressLocalRecord? freshest = _freshestRecord(local, remote);
    final int currentDayFromFreshest = freshest?.currentDayNumber ?? 1;
    final int currentDayFloor = isCompleted
        ? safeDurationDays
        : (completedDayCount + 1).clamp(1, safeDurationDays);
    final int currentDayNumber = _clampDayCount(
      currentDayFromFreshest < currentDayFloor
          ? currentDayFloor
          : currentDayFromFreshest,
      durationDays: safeDurationDays,
    );

    return ReadingPlanProgress(
      currentDayNumber: currentDayNumber,
      completedDayCount: isCompleted ? safeDurationDays : completedDayCount,
      isStarted: (local?.isStarted ?? false) || (remote?.isStarted ?? false),
      isCompleted: isCompleted,
      startedAtIso: _earliestIso(local?.startedAtIso, remote?.startedAtIso),
      lastOpenedAtIso: freshest?.lastOpenedAtIso,
      completedAtIso: local?.completedAtIso ?? remote?.completedAtIso,
      updatedAtIso: freshest?.updatedAtIso,
    );
  }

  PlanProgressLocalRecord? _freshestRecord(
    PlanProgressLocalRecord? left,
    PlanProgressLocalRecord? right,
  ) {
    if (left == null) {
      return right;
    }
    if (right == null) {
      return left;
    }

    final DateTime leftTime =
        DateTime.tryParse(left.updatedAtIso ?? left.lastOpenedAtIso ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final DateTime rightTime =
        DateTime.tryParse(right.updatedAtIso ?? right.lastOpenedAtIso ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return leftTime.isAfter(rightTime) ? left : right;
  }

  String? _earliestIso(String? left, String? right) {
    final DateTime? leftTime = DateTime.tryParse(left ?? '');
    final DateTime? rightTime = DateTime.tryParse(right ?? '');
    if (leftTime == null) {
      return right;
    }
    if (rightTime == null) {
      return left;
    }
    return leftTime.isBefore(rightTime) ? left : right;
  }

  int _resolveRequestedDayNumber({
    required int? requestedDayNumber,
    required ReadingPlan plan,
  }) {
    final int candidate = requestedDayNumber ?? plan.currentDayNumber;
    if (candidate < 1) {
      return 1;
    }
    if (candidate > plan.safeDurationDays) {
      return plan.safeDurationDays;
    }
    return candidate;
  }

  Future<void> _recordPlanDayOpened({
    required ReadingPlan plan,
    required int dayNumber,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final PlanProgressLocalSnapshot snapshot = await _localStore.load();
    PlanProgressLocalRecord? existing;
    for (final PlanProgressLocalRecord item in snapshot.entries) {
      if (item.planId == plan.id) {
        existing = item;
        break;
      }
    }

    final int safeDurationDays = plan.safeDurationDays;
    final int nextCompletedDayCount = dayNumber >= safeDurationDays
        ? safeDurationDays
        : _clampDayCount(
            [
              existing?.completedDayCount ?? 0,
              dayNumber - 1,
            ].reduce((int a, int b) => a > b ? a : b),
            durationDays: safeDurationDays,
          );
    final bool isCompleted =
        (existing?.isCompleted ?? false) || dayNumber >= safeDurationDays;
    final PlanProgressLocalRecord next = PlanProgressLocalRecord(
      planId: plan.id,
      currentDayNumber: isCompleted ? safeDurationDays : dayNumber,
      completedDayCount: isCompleted ? safeDurationDays : nextCompletedDayCount,
      isStarted: true,
      isCompleted: isCompleted,
      startedAtIso: existing?.startedAtIso ?? now.toIso8601String(),
      lastOpenedAtIso: now.toIso8601String(),
      completedAtIso: isCompleted
          ? (existing?.completedAtIso ?? now.toIso8601String())
          : existing?.completedAtIso,
      updatedAtIso: now.toIso8601String(),
    );

    final List<PlanProgressLocalRecord> nextEntries = <PlanProgressLocalRecord>[
      next,
      ...snapshot.entries.where(
        (PlanProgressLocalRecord item) => item.planId != plan.id,
      ),
    ];
    await _localStore.save(snapshot.copyWith(entries: nextEntries));

    final String? userId = _authenticatedUserId;
    if (_isConfigured && userId != null) {
      try {
        await _client!.from('user_reading_plan_progress').upsert(
          <String, dynamic>{
            'user_id': userId,
            'plan_id': plan.id,
            'current_day_number': next.currentDayNumber,
            'completed_day_count': next.completedDayCount,
            'started_at': next.startedAtIso,
            'last_opened_at': next.lastOpenedAtIso,
            'completed_at': next.completedAtIso,
          },
          onConflict: 'user_id,plan_id',
        );
      } catch (_) {
        // Local persistence already succeeded. Remote sync can retry later.
      }
    }

    _notifyChanged();
  }

  Future<void> _syncLocalProgressToRemoteIfNeeded({
    required List<_PlanCatalogRow> catalog,
    required Map<String, PlanProgressLocalRecord> localProgress,
    required Map<String, PlanProgressLocalRecord> remoteProgress,
  }) async {
    final String? userId = _authenticatedUserId;
    if (!_isConfigured || userId == null || localProgress.isEmpty) {
      return;
    }

    final Map<String, int> durationByPlanId = <String, int>{
      for (final _PlanCatalogRow row in catalog) row.plan.id: row.plan.durationDays,
    };
    final List<Map<String, dynamic>> upserts = <Map<String, dynamic>>[];
    for (final MapEntry<String, PlanProgressLocalRecord> entry
        in localProgress.entries) {
      final int safeDurationDays = durationByPlanId[entry.key] ?? 1;
      final PlanProgressLocalRecord merged = _mergeProgress(
        local: entry.value,
        remote: remoteProgress[entry.key],
        durationDays: safeDurationDays,
      ).let(
        (ReadingPlanProgress progress) => PlanProgressLocalRecord(
          planId: entry.key,
          currentDayNumber: progress.currentDayNumber,
          completedDayCount: progress.completedDayCount,
          isStarted: progress.isStarted,
          isCompleted: progress.isCompleted,
          startedAtIso: progress.startedAtIso,
          lastOpenedAtIso: progress.lastOpenedAtIso,
          completedAtIso: progress.completedAtIso,
          updatedAtIso: progress.updatedAtIso,
        ),
      );
      final PlanProgressLocalRecord? remote = remoteProgress[entry.key];
      if (!_shouldUpsertRemote(local: merged, remote: remote)) {
        continue;
      }

      upserts.add(<String, dynamic>{
        'user_id': userId,
        'plan_id': merged.planId,
        'current_day_number': merged.currentDayNumber,
        'completed_day_count': merged.completedDayCount,
        'started_at': merged.startedAtIso,
        'last_opened_at': merged.lastOpenedAtIso,
        'completed_at': merged.completedAtIso,
      });
    }

    if (upserts.isEmpty) {
      return;
    }

    try {
      await _client!
          .from('user_reading_plan_progress')
          .upsert(upserts, onConflict: 'user_id,plan_id');
    } catch (_) {
      // Best-effort sync only.
    }
  }

  bool _shouldUpsertRemote({
    required PlanProgressLocalRecord local,
    required PlanProgressLocalRecord? remote,
  }) {
    if (remote == null) {
      return true;
    }

    final DateTime localTime =
        DateTime.tryParse(local.updatedAtIso ?? local.lastOpenedAtIso ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final DateTime remoteTime =
        DateTime.tryParse(remote.updatedAtIso ?? remote.lastOpenedAtIso ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    if (localTime.isAfter(remoteTime)) {
      return true;
    }

    return local.completedDayCount > remote.completedDayCount;
  }

  int _clampDayCount(int value, {required int durationDays}) {
    if (value < 0) {
      return 0;
    }
    if (value > durationDays) {
      return durationDays;
    }
    return value;
  }

  void _notifyChanged() {
    _revision.value++;
  }
}

class _PlanCatalogRow {
  const _PlanCatalogRow({
    required this.sortOrder,
    required this.plan,
  });

  final int sortOrder;
  final ReadingPlan plan;
}

extension<T> on T {
  R let<R>(R Function(T value) callback) {
    return callback(this);
  }
}
