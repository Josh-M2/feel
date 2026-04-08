import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/bootstrap/app_bootstrap_controller.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'core/supabase/supabase_deep_link_builder.dart';
import 'features/auth/data/local/shared_prefs_guest_local_store.dart';
import 'features/auth/data/repositories/supabase_session_repository.dart';
import 'features/auth/data/repositories/supabase_user_preferences_repository.dart';
import 'features/auth/data/repositories/supabase_user_profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseClient = await SupabaseBootstrap.initializeIfConfigured();
  final AppBootstrapController bootstrap = AppBootstrapController(
    guestLocalStore: SharedPrefsGuestLocalStore(),
    sessionRepository: SupabaseSessionRepository(
      client: supabaseClient,
      deepLinks: const SupabaseDeepLinkBuilder(),
    ),
    profileRepository: SupabaseUserProfileRepository(client: supabaseClient),
    preferencesRepository: SupabaseUserPreferencesRepository(
      client: supabaseClient,
    ),
  );

  await bootstrap.initialize();

  runApp(BibleApp(bootstrap: bootstrap));
}
