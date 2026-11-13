
class AppConfig {
  AppConfig._();

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');
  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get useSupabase =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  static const bool useLocalAuthentication = true;
}
