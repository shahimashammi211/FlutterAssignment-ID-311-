import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_config.dart';

class SupabaseOptionalService {
  SupabaseOptionalService._();

  static bool get enabled => AppConfig.useSupabase;
  static String get projectUrl => AppConfig.supabaseUrl;
  static String get publishableKey => AppConfig.supabasePublishableKey;

  static bool get isConfigured =>
      projectUrl.startsWith('https://') && publishableKey.isNotEmpty;

  static bool _initialized = false;

  static Future<void> initializeIfEnabled() async {
    if (!enabled || !isConfigured || _initialized) return;

    await Supabase.initialize(
      url: projectUrl,
      publishableKey: publishableKey,
    );
    _initialized = true;
  }

  static SupabaseClient? get client {
    if (!enabled || !isConfigured || !_initialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
}
