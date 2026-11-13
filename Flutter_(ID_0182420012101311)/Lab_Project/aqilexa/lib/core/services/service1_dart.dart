
import 'service2_dart.dart';

class AuthService {
  AuthService._();

  static LocalUser? get currentUser =>
      LocalAuthService.currentUser;

  static String? get currentUserId => currentUser?.id;

  static Future<LocalUser> signIn({
    required String email,
    required String password,
    bool rememberMe = true,
  }) =>
      LocalAuthService.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

  static Future<void> signOut() =>
      LocalAuthService.signOut();
}
