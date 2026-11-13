
class NoteModel {
  final String id;
  final String notebookId;
  final String courseId;
  final String title;
  final String question;
  final String answer;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.notebookId,
    required this.courseId,
    required this.title,
    this.question = '',
    this.answer = '',
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebookId': notebookId,
      'courseId': courseId,
      'title': title,
      'question': question,
      'answer': answer,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id']?.toString() ?? '',
      notebookId: map['notebookId']?.toString() ?? '',
      courseId: map['courseId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      question: map['question']?.toString() ?? '',
      answer: map['answer']?.toString() ?? '',
      attachments: (map['attachments'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
            map['updatedAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }

  NoteModel copyWith({
    String? title,
    String? question,
    String? answer,
    List<String>? attachments,
  }) {
    return NoteModel(
      id: id,
      notebookId: notebookId,
      courseId: courseId,
      title: title ?? this.title,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
