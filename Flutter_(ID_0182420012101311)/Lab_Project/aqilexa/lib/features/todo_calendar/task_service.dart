
import '../../core/services/firestore_service.dart';
import '../../models/task_model.dart';

class TaskService {
  static const _c = 'tasks';

  static Future<String> add(TaskModel t) =>
      FirestoreService.addDocument(
        collection: _c,
        data: t.toMap(),
      );

  static Future<List<TaskModel>> getAll() async =>
      (await FirestoreService.getDocuments(collection: _c))
          .map(TaskModel.fromMap)
          .toList();

  static Stream<List<TaskModel>> stream() =>
      FirestoreService.streamDocuments(collection: _c).map(
        (v) => v.map(TaskModel.fromMap).toList(),
      );

  static Future<void> update(TaskModel t) =>
      FirestoreService.setDocument(
        collection: _c,
        documentId: t.id,
        data: t.toMap(),
      );

  static Future<void> delete(String id) =>
      FirestoreService.deleteDocument(
        collection: _c,
        documentId: id,
      );
}
