
import 'package:flutter/material.dart';

import '../../core/services/dataservice.dart';
import '../../core/theme/app_colors.dart';

class NotebookPageScreen extends StatefulWidget {
  final String notebookId;
  final String title;

  const NotebookPageScreen({
    super.key,
    required this.notebookId,
    required this.title,
  });

  @override
  State<NotebookPageScreen> createState() => _NotebookPageScreenState();
}

class _NotebookPageScreenState extends State<NotebookPageScreen> {
  List<Map<String, dynamic>> notes = [];

  final question = TextEditingController();
  final answer = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    question.dispose();
    answer.dispose();
    super.dispose();
  }

  void _load() {
    final all = LocalDataService.list('notebooks');

    Map<String, dynamic>? notebook;

    for (final item in all) {
      if (item['id'] == widget.notebookId) {
        notebook = item;
        break;
      }
    }

    notes = notebook == null
        ? []
        : (notebook['notes'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
  }

  Future<void> _saveNote({String? noteId}) async {
    final all = LocalDataService.list('notebooks');

    final index = all.indexWhere(
      (e) => e['id'] == widget.notebookId,
    );

    if (index < 0) return;

    final list = (all[index]['notes'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    if (noteId == null) {
      list.add({
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'question': question.text.trim(),
        'answer': answer.text.trim(),
      });
    } else {
      final noteIndex = list.indexWhere(
        (e) => e['id'] == noteId,
      );

      if (noteIndex >= 0) {
        list[noteIndex]['question'] = question.text.trim();
        list[noteIndex]['answer'] = answer.text.trim();
      }
    }

    all[index]['notes'] = list;

    await LocalDataService.saveList('notebooks', all);

    question.clear();
    answer.clear();

    if (mounted) setState(() => notes = list);
  }

  Future<void> _noteDialog({
    Map<String, dynamic>? note,
  }) async {
    question.text = note?['question'] ?? '';
    answer.text = note?['answer'] ?? '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          note == null ? 'Add note' : 'Edit note',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: question,
                decoration: const InputDecoration(
                  labelText: 'Question / Topic',
                ),
              ),
              TextField(
                controller: answer,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Answer / Notes',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (question.text.trim().isEmpty) return;

              await _saveNote(noteId: note?['id']);

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(String id) async {
    final all = LocalDataService.list('notebooks');

    final index = all.indexWhere(
      (e) => e['id'] == widget.notebookId,
    );

    if (index < 0) return;

    final list = (all[index]['notes'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList()
      ..removeWhere((e) => e['id'] == id);

    all[index]['notes'] = list;

    await LocalDataService.saveList('notebooks', all);

    if (mounted) setState(() => notes = list);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _noteDialog(),
          child: const Icon(Icons.add),
        ),
        body: notes.isEmpty
            ? const Center(
                child: Text('No notes in this notebook yet.'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return Card(
                    color: AppColors.surface,
                    child: ExpansionTile(
                      title: Text(
                        note['question'] ?? 'Untitled',
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(note['answer'] ?? ''),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _noteDialog(note: note),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              onPressed: () => _deleteNote(note['id']),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      );
}
