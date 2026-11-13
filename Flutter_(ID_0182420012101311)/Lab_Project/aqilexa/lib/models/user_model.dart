
class UserModel {
  final String uid, name, email;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        uid: m['uid']?.toString() ?? '',
        name: m['name']?.toString() ?? '',
        email: m['email']?.toString() ?? '',
        createdAt: DateTime.tryParse(
          m['createdAt']?.toString() ?? '',
        ),
      );
}
