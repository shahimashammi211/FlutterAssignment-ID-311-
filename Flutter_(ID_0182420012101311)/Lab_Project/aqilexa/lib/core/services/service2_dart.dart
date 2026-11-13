
import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'database.dart';

class LocalUser {
  final String id, firstName, lastName, fullName, email;
  final String? photoBase64;

  const LocalUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.photoBase64,
  });

  factory LocalUser.fromMap(Map data) => LocalUser(
        id: data['id'] as String,
        firstName: (data['firstName'] ?? '') as String,
        lastName: (data['lastName'] ?? '') as String,
        fullName: (data['fullName'] ?? '') as String,
        email: (data['email'] ?? '') as String,
        photoBase64: data['photoBase64'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': fullName,
        'email': email,
        'photoBase64': photoBase64,
      };
}

class LocalAuthService {
  LocalAuthService._();

  static const _usersKey = 'users';
  static const _sessionKey = 'remembered_user_id';

  static String? _memorySession;

  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 120000,
    bits: 256,
  );

  static final _random = Random.secure();

  static List<Map> _users() =>
      (LocalDatabase.get(_usersKey, <dynamic>[]) as List).cast<Map>();

  static LocalUser? get currentUser {
    final stored = LocalDatabase.get(_sessionKey);
    final id = _memorySession ?? (stored is String ? stored : null);

    if (id == null) return null;

    for (final map in _users()) {
      if (map['id'] == id) return LocalUser.fromMap(map);
    }

    return null;
  }

  static Future<LocalUser?> restoreSession() async => currentUser;

  static Future<String> _hash(
    String password,
    List<int> salt,
  ) async {
    final key = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    return base64Encode(await key.extractBytes());
  }

  static Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String recoveryCode,
    String? photoBase64,
  }) async {
    final normalized = email.trim().toLowerCase();

    if (_users().any(
      (u) => (u['email'] as String).toLowerCase() == normalized,
    )) {
      throw Exception('An account with this email already exists.');
    }

    final salt = List<int>.generate(
      16,
      (_) => _random.nextInt(256),
    );

    final recoverySalt = List<int>.generate(
      16,
      (_) => _random.nextInt(256),
    );

    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final first = firstName.trim(), last = lastName.trim();

    final record = <String, dynamic>{
      'id': id,
      'firstName': first,
      'lastName': last,
      'fullName': '$first $last'.trim(),
      'email': normalized,
      'photoBase64': photoBase64,
      'passwordSalt': base64Encode(salt),
      'passwordHash': await _hash(password, salt),
      'recoverySalt': base64Encode(recoverySalt),
      'recoveryHash': await _hash(
        recoveryCode.trim(),
        recoverySalt,
      ),
      'createdAt': DateTime.now().toIso8601String(),
    };

    final users = _users()..add(record);

    await LocalDatabase.put(_usersKey, users);

    return id;
  }

  static Future<LocalUser> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final normalized = email.trim().toLowerCase();

    for (final user in _users()) {
      if ((user['email'] as String).toLowerCase() == normalized) {
        final salt = base64Decode(user['passwordSalt'] as String);
        final hash = await _hash(password, salt);

        if (hash != user['passwordHash']) break;

        _memorySession = user['id'] as String;

        if (rememberMe) {
          await LocalDatabase.put(_sessionKey, _memorySession);
        } else {
          await LocalDatabase.delete(_sessionKey);
        }

        return LocalUser.fromMap(user);
      }
    }

    throw Exception('Invalid email or password.');
  }

  static Future<void> resetPassword({
    required String email,
    required String recoveryCode,
    required String newPassword,
  }) async {
    final users = _users();

    final index = users.indexWhere(
      (u) => (u['email'] as String).toLowerCase() ==
          email.trim().toLowerCase(),
    );

    if (index < 0) {
      throw Exception('No local account found for this email.');
    }

    final user = Map<String, dynamic>.from(users[index]);

    final salt = base64Decode(user['recoverySalt'] as String);

    if (await _hash(recoveryCode.trim(), salt) != user['recoveryHash']) {
      throw Exception('Recovery code is incorrect.');
    }

    final newSalt = List<int>.generate(
      16,
      (_) => _random.nextInt(256),
    );

    user['passwordSalt'] = base64Encode(newSalt);
    user['passwordHash'] = await _hash(newPassword, newSalt);

    users[index] = user;

    await LocalDatabase.put(_usersKey, users);
  }

  static Future<void> signOut() async {
    _memorySession = null;

    await LocalDatabase.delete(_sessionKey);
  }

  static Future<void> updateProfile({
    required String userId,
    required String firstName,
    required String lastName,
    String? photoBase64,
  }) async {
    final users = _users();

    final index = users.indexWhere((u) => u['id'] == userId);

    if (index < 0) return;

    final user = Map<String, dynamic>.from(users[index]);

    user['firstName'] = firstName;
    user['lastName'] = lastName;
    user['fullName'] = '$firstName $lastName'.trim();

    if (photoBase64 != null) {
      user['photoBase64'] = photoBase64;
    }

    users[index] = user;

    await LocalDatabase.put(_usersKey, users);
  }
}
