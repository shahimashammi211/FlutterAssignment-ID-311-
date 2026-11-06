import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class AuthService {
  final SupabaseClient supabase = SupabaseService.client;

  User? get currentUser => supabase.auth.currentUser;

  Future<AuthResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim()},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<bool> signInWithGoogle() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'aqilexa://login-callback/',
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}