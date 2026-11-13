
class FocusSessionModel {
  final String id;
  final String courseId;
  final int durationMinutes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  const FocusSessionModel({
    required this.id,
    required this.courseId,
    required this.durationMinutes,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'durationMinutes': durationMinutes,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory FocusSessionModel.fromMap(Map<String, dynamic> map) {
    return FocusSessionModel(
      id: map['id']?.toString() ?? '',
      courseId: map['courseId']?.toString() ?? '',
      durationMinutes:
          (map['durationMinutes'] as num?)?.toInt() ?? 0,
      startedAt: DateTime.tryParse(
            map['startedAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      completedAt: map['completedAt'] == null
          ? null
          : DateTime.tryParse(map['completedAt'].toString()),
      isCompleted: map['isCompleted'] == true,
    );
  }

  FocusSessionModel copyWith({
    String? courseId,
    int? durationMinutes,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return FocusSessionModel(
      id: id,
      courseId: courseId ?? this.courseId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
