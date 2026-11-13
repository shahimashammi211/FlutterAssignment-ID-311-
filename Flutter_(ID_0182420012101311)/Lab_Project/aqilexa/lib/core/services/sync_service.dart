import 'package:supabase_flutter/supabase_flutter.dart';
import 'optionalservice.dart';


class SupabaseSyncService {
  SupabaseSyncService._();

  static SupabaseClient get _client {
    final client = SupabaseOptionalService.client;
    if (client == null) {
      throw StateError('Cloud sync is unavailable while Supabase is disabled.');
    }
    return client;
  }

  static Future<void> upsertRows({
    required String table,
    required List<Map<String, dynamic>> rows,
  }) async {
    if (rows.isEmpty) return;
    await _client.from(table).upsert(rows);
  }
}
