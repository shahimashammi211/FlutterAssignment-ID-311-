
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final DateTime deadline;
  final bool isCompleted;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.courseId,
    required this.deadline,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      courseId: map['courseId']?.toString() ?? '',
      deadline: DateTime.tryParse(
            map['deadline']?.toString() ?? '',
          ) ??
          DateTime.now(),
      isCompleted: map['isCompleted'] == true,
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }

  TaskModel copyWith({
    String? title,
    String? description,
    String? courseId,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
