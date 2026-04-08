class SupabaseKeys {
  SupabaseKeys._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL',
  );
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );
  static const String bibleSourceBaseUrl = String.fromEnvironment(
    'BIBLE_SOURCE_BASE_URL',
    defaultValue: '',
  );
  static const String bibleSourceApiKey = String.fromEnvironment(
    'BIBLE_SOURCE_API_KEY',
    defaultValue: '',
  );

  static bool get isConfigured {
    return url.isNotEmpty &&
        anonKey.isNotEmpty &&
        url != 'YOUR_SUPABASE_URL' &&
        anonKey != 'YOUR_SUPABASE_ANON_KEY';
  }
}
