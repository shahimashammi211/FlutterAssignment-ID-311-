
import 'database.dart';
import 'service2_dart.dart';

class LocalDataService {
  LocalDataService._();

  static String get _uid =>
      LocalAuthService.currentUser?.id ?? 'guest';

  static String _key(String type) => '${type}_$_uid';

  static List<Map<String, dynamic>> list(String type) =>
      (LocalDatabase.get(_key(type), <dynamic>[]) as List)
          .map(
            (e) => Map<String, dynamic>.from(e as Map),
          )
          .toList();

  static Future<void> saveList(
    String type,
    List<Map<String, dynamic>> items,
  ) =>
      LocalDatabase.put(_key(type), items);

  static Future<void> add(
    String type,
    Map<String, dynamic> item,
  ) async {
    final items = list(type)..add(item);
    await saveList(type, items);
  }

  static Future<void> remove(String type, String id) async {
    final items = list(type)..removeWhere((e) => e['id'] == id);
    await saveList(type, items);
  }
}
