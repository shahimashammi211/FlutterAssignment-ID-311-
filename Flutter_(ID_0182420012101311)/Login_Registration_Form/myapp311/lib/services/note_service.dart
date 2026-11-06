
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class NoteService {
  final SupabaseClient supabase = SupabaseService.client;

  // Read notes in real time
  Stream<List<Map<String, dynamic>>> getNotes() {
    final userId = SupabaseService.currentUserId;

    if (userId == null) {
      return Stream.value([]);
    }

    return supabase
        .from('notes')
        .stream(primaryKey: ['id'])
        .eq('uuid', userId)
        .order('created_at', ascending: false);
  }

  // Create note
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    final userId = SupabaseService.currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    await supabase.from('notes').insert({
      'uuid': userId,
      'title': title,
      'description': description,
    });
  }

  // Update note
  Future<void> updateNote({
    required int noteId,
    required String title,
    required String description,
  }) async {
    await supabase
        .from('notes')
        .update({
          'title': title,
          'description': description,
        })
        .eq('id', noteId)
        .eq('uuid', SupabaseService.currentUserId!);
  }

  // Delete note
  Future<void> deleteNote(int noteId) async {
    await supabase
        .from('notes')
        .delete()
        .eq('id', noteId)
        .eq('uuid', SupabaseService.currentUserId!);
  }
}
