import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  LocalDatabase._();

  static const String boxName = 'aqilexa_local_v1';
  static late Box<dynamic> box;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    box = await Hive.openBox<dynamic>(boxName);
  }


  static Future<void> initializeAt(String path) async {
    Hive.init(path);
    box = await Hive.openBox<dynamic>(boxName);
  }

  static dynamic get(String key, [dynamic fallback]) =>
      box.get(key, defaultValue: fallback);

  static Future<void> put(String key, dynamic value) =>
      box.put(key, value);

  static Future<void> delete(String key) => box.delete(key);
}
