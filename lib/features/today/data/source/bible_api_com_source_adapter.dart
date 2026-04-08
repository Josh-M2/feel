import 'dart:convert';
import 'dart:io';

import '../../domain/models/bible_source_passage.dart';
import '../../domain/models/bible_source_verse.dart';
import '../../domain/repositories/bible_source_adapter.dart';

class BibleApiComSourceAdapter implements BibleSourceAdapter {
  BibleApiComSourceAdapter({this.baseUrl = 'https://bible-api.com'});

  final String baseUrl;

  @override
  Future<BibleSourceVerse?> fetchVerseByReference({
    required String reference,
    required String translationCode,
  }) async {
    final Map<String, dynamic>? json = await _fetchJson(
      reference: reference,
      translationCode: translationCode,
    );
    if (json == null) return null;

    final String text = json['text']?.toString().trim() ?? '';
    if (text.isEmpty) return null;

    return BibleSourceVerse(
      reference: _sourceReference(json, reference),
      text: text.replaceAll(RegExp(r'\s+'), ' ').trim(),
      translationCode: translationCode,
      translationLabel: _translationLabel(json, translationCode),
    );
  }

  @override
  Future<BibleSourcePassage?> fetchPassageByReference({
    required String reference,
    required String translationCode,
  }) async {
    final Map<String, dynamic>? json = await _fetchJson(
      reference: reference,
      translationCode: translationCode,
    );
    if (json == null) return null;

    final List<dynamic> versesJson = json['verses'] as List<dynamic>? ?? const <dynamic>[];
    final List<BibleSourcePassageVerse> verses = versesJson
        .map((dynamic item) => Map<String, dynamic>.from(item as Map))
        .map((Map<String, dynamic> item) {
          final int number = (item['verse'] as num?)?.toInt() ?? 0;
          final String text = item['text']?.toString().replaceAll(RegExp(r'\s+'), ' ').trim() ?? '';
          return BibleSourcePassageVerse(number: number, text: text);
        })
        .where((BibleSourcePassageVerse verse) => verse.number > 0 && verse.text.isNotEmpty)
        .toList(growable: false);

    if (verses.isEmpty) return null;

    return BibleSourcePassage(
      reference: _sourceReference(json, reference),
      translationCode: translationCode,
      translationLabel: _translationLabel(json, translationCode),
      verses: verses,
    );
  }

  Future<Map<String, dynamic>?> _fetchJson({
    required String reference,
    required String translationCode,
  }) async {
    HttpClient? httpClient;
    try {
      final String encodedReference = Uri.encodeComponent(reference);
      final Uri uri = Uri.parse(
        '$baseUrl/$encodedReference?translation=$translationCode',
      );
      httpClient = HttpClient();
      final HttpClientRequest request = await httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final HttpClientResponse response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final String body = await response.transform(utf8.decoder).join();
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    } finally {
      httpClient?.close(force: true);
    }
  }

  String _sourceReference(Map<String, dynamic> json, String fallbackReference) {
    final String value = json['reference']?.toString().trim() ?? '';
    return value.isEmpty ? fallbackReference : value;
  }

  String _translationLabel(Map<String, dynamic> json, String translationCode) {
    final String value = json['translation_name']?.toString().trim() ?? '';
    final String label = value.isEmpty ? translationCode.toUpperCase() : value;
    return '$label via Bible API';
  }
}
