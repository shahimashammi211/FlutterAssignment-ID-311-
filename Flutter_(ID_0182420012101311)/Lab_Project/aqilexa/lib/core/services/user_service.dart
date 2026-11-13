
import 'service2_dart.dart';

class UserService {
  UserService._();

  static Future<void> createUserProfile({
    required String name,
    required String email,
  }) async {}

  static Future<Map<String, dynamic>?> getUserProfile() async =>
      LocalAuthService.currentUser?.toMap();

  static Future<void> updateUserProfile({
    required String name,
  }) async {
    final user = LocalAuthService.currentUser;

    if (user != null) {
      await LocalAuthService.updateProfile(
        userId: user.id,
        firstName: name,
        lastName: '',
      );
    }
  }

  static Future<void> deleteUserProfile() async =>
      LocalAuthService.signOut();
}
