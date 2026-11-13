
import 'dart:convert';

class StorageService {
  StorageService._();

  static Future<String> uploadBytes({
    required String path,
    required List<int> bytes,
    String? contentType,
  }) async =>
      'data:${contentType ?? 'application/octet-stream'};base64,${base64Encode(bytes)}';

  static Future<void> delete(String url) async {}
}
