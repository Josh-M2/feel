import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_keys.dart';

class SupabaseBootstrap {
  SupabaseBootstrap._();

  static Future<SupabaseClient?> initializeIfConfigured() async {
    if (!SupabaseKeys.isConfigured) {
      return null;
    }

    await Supabase.initialize(
      url: SupabaseKeys.url,
      anonKey: SupabaseKeys.anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    return Supabase.instance.client;
  }
}
