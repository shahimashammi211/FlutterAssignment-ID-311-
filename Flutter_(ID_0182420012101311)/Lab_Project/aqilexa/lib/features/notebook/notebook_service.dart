
import '../../core/services/firestore_service.dart';
import '../../models/notebook_model.dart';

class NotebookService {
  static const _c = 'notes';

  static Future<String> add(NoteModel n) =>
      FirestoreService.addDocument(
        collection: _c,
        data: n.toMap(),
      );

  static Future<List<NoteModel>> getAll() async =>
      (await FirestoreService.getDocuments(collection: _c))
          .map(NoteModel.fromMap)
          .toList();

  static Stream<List<NoteModel>> stream() =>
      FirestoreService.streamDocuments(collection: _c).map(
        (v) => v.map(NoteModel.fromMap).toList(),
      );

  static Future<void> update(NoteModel n) =>
      FirestoreService.setDocument(
        collection: _c,
        documentId: n.id,
        data: n.toMap(),
      );

  static Future<void> delete(String id) =>
      FirestoreService.deleteDocument(
        collection: _c,
        documentId: id,
      );
}
