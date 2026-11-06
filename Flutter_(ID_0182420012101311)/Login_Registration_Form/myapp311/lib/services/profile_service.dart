
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class ProfileService {
  final SupabaseClient supabase = SupabaseService.client;

  // Get profile information
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = SupabaseService.currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  // Update profile name
  Future<void> updateProfile({
    required String name,
  }) async {
    final user = SupabaseService.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await supabase.from('profiles').upsert({
      'id': user.id,
      'name': name,
      'email': user.email,
    });

    await supabase.auth.updateUser(
      UserAttributes(
        data: {'name': name},
      ),
    );
  }
}
