
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client =
      Supabase.instance.client;

  static User? get currentUser {
    return client.auth.currentUser;
  }

  static String? get currentUserId {
    return currentUser?.id;
  }
}
