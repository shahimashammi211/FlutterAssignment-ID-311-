
import 'package:flutter/material.dart';

import '../../core/services/dataservice.dart';
import '../../core/theme/app_colors.dart';
import 'notebook_page_screen.dart';

class NotebookScreen extends StatefulWidget {
  const NotebookScreen({super.key});

  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen> {
  List<Map<String, dynamic>> notebooks = [];

  final title = TextEditingController();
  final course = TextEditingController();

  @override
  void initState() {
    super.initState();
    notebooks = LocalDataService.list('notebooks');
  }

  @override
  void dispose() {
    title.dispose();
    course.dispose();
    super.dispose();
  }

  Future<void> _dialog({
    Map<String, dynamic>? notebook,
  }) async {
    title.text = notebook?['title'] ?? '';
    course.text = notebook?['course'] ?? '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          notebook == null ? 'Create Notebook' : 'Edit Notebook',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: 'Notebook name',
              ),
            ),
            TextField(
              controller: course,
              decoration: const InputDecoration(
                labelText: 'Course name',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (title.text.trim().isEmpty) return;

              final all = LocalDataService.list('notebooks');

              if (notebook == null) {
                all.add({
                  'id': DateTime.now().microsecondsSinceEpoch.toString(),
                  'title': title.text.trim(),
                  'course': course.text.trim(),
                  'notes': <Map<String, dynamic>>[],
                });
              } else {
                final index = all.indexWhere(
                  (e) => e['id'] == notebook['id'],
                );

                if (index >= 0) {
                  all[index]['title'] = title.text.trim();
                  all[index]['course'] = course.text.trim();
                }
              }

              await LocalDataService.saveList('notebooks', all);

              if (mounted) {
                setState(
                  () => notebooks = LocalDataService.list('notebooks'),
                );
              }

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

  Future<void> _delete(Map<String, dynamic> notebook) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete notebook?'),
        content: const Text(
          'This will also delete all notes inside it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (yes == true) {
      await LocalDataService.remove('notebooks', notebook['id']);

      if (mounted) {
        setState(
          () => notebooks = LocalDataService.list('notebooks'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Notebook'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _dialog(),
          icon: const Icon(Icons.add),
          label: const Text('New Notebook'),
        ),
        body: notebooks.isEmpty
            ? const Center(
                child: Text(
                  'No notebooks yet. Create your first notebook.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notebooks.length,
                itemBuilder: (context, index) {
                  final notebook = notebooks[index];

                  final noteCount =
                      (notebook['notes'] as List?)?.length ?? 0;

                  return Card(
                    color: AppColors.surface,
                    child: ListTile(
                      leading: const Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.silver,
                      ),
                      title: Text(notebook['title'] ?? ''),
                      subtitle: Text(
                        '${notebook['course'] ?? ''} • $noteCount notes',
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotebookPageScreen(
                              notebookId: notebook['id'],
                              title: notebook['title'],
                            ),
                          ),
                        );

                        if (mounted) {
                          setState(
                            () => notebooks =
                                LocalDataService.list('notebooks'),
                          );
                        }
                      },
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _dialog(notebook: notebook);
                          }

                          if (value == 'delete') {
                            _delete(notebook);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      );
}
