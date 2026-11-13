
class CourseModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final DateTime createdAt;

  const CourseModel({
    required this.id,
    required this.name,
    required this.code,
    this.description = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      code: map['code'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }

  CourseModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    DateTime? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
