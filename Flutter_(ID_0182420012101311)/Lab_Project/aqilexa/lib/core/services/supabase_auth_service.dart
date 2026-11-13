import 'package:supabase_flutter/supabase_flutter.dart';
import 'optionalservice.dart';

class SupabaseAuthService {
  SupabaseAuthService._();

  static SupabaseClient get _client {
    final client = SupabaseOptionalService.client;
    if (client == null) {
      throw StateError('Supabase is disabled or has not been configured.');
    }
    return client;
  }

  static Future<AuthResponse> register({
    required String email,
    required String password,
  }) => _client.auth.signUp(email: email.trim(), password: password);

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) => _client.auth.signInWithPassword(email: email.trim(), password: password);

  static Future<void> sendPasswordReset({required String email}) =>
      _client.auth.resetPasswordForEmail(email.trim());

  static Future<void> signOut() => _client.auth.signOut();
}
