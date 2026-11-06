
class SupabaseConfig {
  SupabaseConfig._();

  // Supabase Project URL
  static const String supabaseUrl =
      'https://qzsnseogxganuxiicxgj.supabase.co';

  // Supabase Publishable Key
  static const String supabasePublishableKey =
      'sb_publishable_MGrk7K5NkBxmnm9k0UN5IQ_yEVHe2TR';

  // Configuration Check
  static bool get isConfigured {
    return supabaseUrl ==
            'https://qzsnseogxganuxiicxgj.supabase.co' &&
        supabasePublishableKey.startsWith('sb_publishable_');
  }
}
