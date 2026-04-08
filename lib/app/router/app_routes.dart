class AppRoutes {
  AppRoutes._();

  // Onboarding
  static const String splash = '/splash';
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingVersePreferences =
      '/onboarding/verse-preferences';
  static const String onboardingDailyNotificationTime =
      '/onboarding/daily-notification-time';
  static const String onboardingNotificationPermission =
      '/onboarding/notification-permission';
  static const String onboardingFinish = '/onboarding/finish';

  // Auth utility routes
  static const String authCallback = '/auth/callback';
  static const String authResetPassword = '/auth/reset_password';

  // Today
  static const String todayHome = '/tab_today/home';
  static const String todayVerseDetail = '/tab_today/verse_detail';
  static const String todayVerseContext = '/tab_today/verse_context';
  static const String todayVerseAiExplain = '/tab_today/verse_ai_explain';
  static const String todaySharePreview = '/tab_today/share_preview';

  // Read
  static const String readBooks = '/tab_read/books';
  static const String readBookDetail = '/tab_read/book_detail';
  static const String readChapterRead = '/tab_read/chapter_read';
  static const String readReferenceSearch = '/tab_read/reference_search';
  static const String readContinueReading = '/tab_read/continue_reading';

  // Plans
  static const String plansList = '/tab_plans/list';
  static const String plansPlanDetail = '/tab_plans/plan_detail';
  static const String plansDayRead = '/tab_plans/day_read';
  static const String plansProgress = '/tab_plans/progress';

  // Saved
  static const String savedBookmarks = '/tab_saved/bookmarks';
  static const String savedHighlights = '/tab_saved/highlights';
  static const String savedNotes = '/tab_saved/notes';
  static const String savedHistory = '/tab_saved/history';

  // Global profile
  static const String profileOverview = '/global_profile/overview';
  static const String profileAuthStatus = '/global_profile/auth_status';
  static const String profileSignIn = '/global_profile/sign_in';
  static const String profileSignUp = '/global_profile/sign_up';
  static const String profileDataSync = '/global_profile/data_sync';
  static const String profileSignOut = '/global_profile/sign_out';

  // Global settings
  static const String settingsHome = '/global_settings/home';
  static const String settingsContentPreferences =
      '/global_settings/content_preferences';
  static const String settingsNotifications = '/global_settings/notifications';
  static const String settingsWidgetPreferences =
      '/global_settings/widget_preferences';
  static const String settingsSupportHome = '/global_settings/support_home';
  static const String settingsSupportMaintenanceFund =
      '/global_settings/support_maintenance_fund';
  static const String settingsSupportTransparency =
      '/global_settings/support_transparency';
  static const String settingsSupportCoffee = '/global_settings/support_coffee';
  static const String settingsPrivacy = '/global_settings/privacy';
  static const String settingsAbout = '/global_settings/about';
}
