import 'app_preference_snapshot.dart';

class AppPreferenceDomainSyncState {
  const AppPreferenceDomainSyncState({
    required this.updatedAt,
    this.lastSyncedAt,
    this.lastSyncedUserId,
  });

  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? lastSyncedUserId;

  factory AppPreferenceDomainSyncState.defaults() {
    return AppPreferenceDomainSyncState(
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  AppPreferenceDomainSyncState copyWith({
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    bool clearLastSyncedAt = false,
    String? lastSyncedUserId,
    bool clearLastSyncedUserId = false,
  }) {
    return AppPreferenceDomainSyncState(
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: clearLastSyncedAt ? null : (lastSyncedAt ?? this.lastSyncedAt),
      lastSyncedUserId: clearLastSyncedUserId
          ? null
          : (lastSyncedUserId ?? this.lastSyncedUserId),
    );
  }

  AppPreferenceDomainSyncState markLocalChange({
    required DateTime timestamp,
    required String? pendingUserId,
  }) {
    return AppPreferenceDomainSyncState(
      updatedAt: timestamp.toUtc(),
      lastSyncedAt: lastSyncedAt,
      lastSyncedUserId: pendingUserId ?? lastSyncedUserId,
    );
  }

  AppPreferenceDomainSyncState markSynced({
    required DateTime timestamp,
    required String userId,
  }) {
    final DateTime normalized = timestamp.toUtc();
    return AppPreferenceDomainSyncState(
      updatedAt: normalized,
      lastSyncedAt: normalized,
      lastSyncedUserId: userId,
    );
  }

  bool hasPendingSyncForUser(String? userId) {
    if (userId == null) {
      return false;
    }
    if (lastSyncedUserId != null && lastSyncedUserId != userId) {
      return false;
    }
    return lastSyncedAt == null || updatedAt.isAfter(lastSyncedAt!);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'lastSyncedUserId': lastSyncedUserId,
    };
  }

  factory AppPreferenceDomainSyncState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AppPreferenceDomainSyncState.defaults();
    }

    return AppPreferenceDomainSyncState(
      updatedAt: _parseTimestamp(json['updatedAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      lastSyncedAt: _parseTimestamp(json['lastSyncedAt']),
      lastSyncedUserId: json['lastSyncedUserId']?.toString(),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString())?.toUtc();
  }
}

class AppPreferenceLocalState {
  const AppPreferenceLocalState({
    required this.snapshot,
    required this.content,
    required this.notifications,
    required this.widget,
  });

  final AppPreferenceSnapshot snapshot;
  final AppPreferenceDomainSyncState content;
  final AppPreferenceDomainSyncState notifications;
  final AppPreferenceDomainSyncState widget;

  factory AppPreferenceLocalState.defaults() {
    return AppPreferenceLocalState(
      snapshot: AppPreferenceSnapshot.defaults(),
      content: AppPreferenceDomainSyncState.defaults(),
      notifications: AppPreferenceDomainSyncState.defaults(),
      widget: AppPreferenceDomainSyncState.defaults(),
    );
  }

  factory AppPreferenceLocalState.fromLegacySnapshot(
    AppPreferenceSnapshot snapshot,
  ) {
    return AppPreferenceLocalState.defaults().copyWith(snapshot: snapshot);
  }

  AppPreferenceLocalState copyWith({
    AppPreferenceSnapshot? snapshot,
    AppPreferenceDomainSyncState? content,
    AppPreferenceDomainSyncState? notifications,
    AppPreferenceDomainSyncState? widget,
  }) {
    return AppPreferenceLocalState(
      snapshot: snapshot ?? this.snapshot,
      content: content ?? this.content,
      notifications: notifications ?? this.notifications,
      widget: widget ?? this.widget,
    );
  }

  AppPreferenceDomainSyncState stateFor(AppPreferenceDomain domain) {
    switch (domain) {
      case AppPreferenceDomain.content:
        return content;
      case AppPreferenceDomain.notifications:
        return notifications;
      case AppPreferenceDomain.widget:
        return widget;
    }
  }

  AppPreferenceLocalState updateDomainState(
    AppPreferenceDomain domain,
    AppPreferenceDomainSyncState nextState,
  ) {
    switch (domain) {
      case AppPreferenceDomain.content:
        return copyWith(content: nextState);
      case AppPreferenceDomain.notifications:
        return copyWith(notifications: nextState);
      case AppPreferenceDomain.widget:
        return copyWith(widget: nextState);
    }
  }

  AppPreferenceLocalState markLocalChange({
    required AppPreferenceDomain domain,
    required DateTime timestamp,
    required String? pendingUserId,
    required AppPreferenceSnapshot snapshot,
  }) {
    return updateDomainState(
      domain,
      stateFor(domain).markLocalChange(
        timestamp: timestamp,
        pendingUserId: pendingUserId,
      ),
    ).copyWith(snapshot: snapshot);
  }

  AppPreferenceLocalState markSynced({
    required AppPreferenceDomain domain,
    required DateTime timestamp,
    required String userId,
    required AppPreferenceSnapshot snapshot,
  }) {
    return updateDomainState(
      domain,
      stateFor(domain).markSynced(timestamp: timestamp, userId: userId),
    ).copyWith(snapshot: snapshot);
  }

  bool hasPendingSyncForUser(String? userId) {
    if (userId == null) {
      return false;
    }

    return AppPreferenceDomain.values.any(
      (AppPreferenceDomain domain) => stateFor(domain).hasPendingSyncForUser(userId),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'snapshot': snapshot.toLocalJson(),
      'domains': <String, dynamic>{
        AppPreferenceDomain.content.name: content.toJson(),
        AppPreferenceDomain.notifications.name: notifications.toJson(),
        AppPreferenceDomain.widget.name: widget.toJson(),
      },
    };
  }

  factory AppPreferenceLocalState.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> snapshotJson = Map<String, dynamic>.from(
      json['snapshot'] as Map? ?? const <String, dynamic>{},
    );
    final Map<String, dynamic> domains = Map<String, dynamic>.from(
      json['domains'] as Map? ?? const <String, dynamic>{},
    );

    return AppPreferenceLocalState(
      snapshot: AppPreferenceSnapshot.fromLocalJson(snapshotJson),
      content: AppPreferenceDomainSyncState.fromJson(
        _coerceMap(domains[AppPreferenceDomain.content.name]),
      ),
      notifications: AppPreferenceDomainSyncState.fromJson(
        _coerceMap(domains[AppPreferenceDomain.notifications.name]),
      ),
      widget: AppPreferenceDomainSyncState.fromJson(
        _coerceMap(domains[AppPreferenceDomain.widget.name]),
      ),
    );
  }

  static Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }
}

class AccountPreferenceSyncSnapshot {
  const AccountPreferenceSyncSnapshot({
    required this.snapshot,
    this.contentUpdatedAt,
    this.notificationsUpdatedAt,
    this.widgetUpdatedAt,
  });

  final AppPreferenceSnapshot snapshot;
  final DateTime? contentUpdatedAt;
  final DateTime? notificationsUpdatedAt;
  final DateTime? widgetUpdatedAt;

  DateTime? updatedAtFor(AppPreferenceDomain domain) {
    switch (domain) {
      case AppPreferenceDomain.content:
        return contentUpdatedAt;
      case AppPreferenceDomain.notifications:
        return notificationsUpdatedAt;
      case AppPreferenceDomain.widget:
        return widgetUpdatedAt;
    }
  }
}
