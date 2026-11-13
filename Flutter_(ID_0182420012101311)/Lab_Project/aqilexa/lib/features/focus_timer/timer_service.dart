
import '../../core/services/firestore_service.dart';
import '../../models/focus_model.dart';

class TimerService {
  static const _c = 'focusSessions';

  static Future<String> save(FocusSessionModel s) =>
      FirestoreService.addDocument(
        collection: _c,
        data: s.toMap(),
      );

  static Future<List<FocusSessionModel>> getAll() async =>
      (await FirestoreService.getDocuments(collection: _c))
          .map(FocusSessionModel.fromMap)
          .toList();
}
