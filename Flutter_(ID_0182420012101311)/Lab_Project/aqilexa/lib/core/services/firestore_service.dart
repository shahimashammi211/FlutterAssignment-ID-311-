
import 'dataservice.dart';

class FirestoreService {
  FirestoreService._();

  static Future<String> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final id = data['id']?.toString() ??
        DateTime.now().microsecondsSinceEpoch.toString();

    await LocalDataService.add(
      collection,
      {...data, 'id': id},
    );

    return id;
  }

  static Future<void> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final items = LocalDataService.list(collection);
    final index = items.indexWhere((e) => e['id'] == documentId);

    if (index < 0) {
      items.add({...data, 'id': documentId});
    } else {
      items[index] = {
        ...items[index],
        ...data,
        'id': documentId,
      };
    }

    await LocalDataService.saveList(collection, items);
  }

  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    for (final item in LocalDataService.list(collection)) {
      if (item['id'] == documentId) return item;
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> getDocuments({
    required String collection,
  }) async =>
      LocalDataService.list(collection);

  static Stream<List<Map<String, dynamic>>> streamDocuments({
    required String collection,
  }) async* {
    yield LocalDataService.list(collection);
  }

  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) =>
      setDocument(
        collection: collection,
        documentId: documentId,
        data: data,
      );

  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) =>
      LocalDataService.remove(collection, documentId);
}
