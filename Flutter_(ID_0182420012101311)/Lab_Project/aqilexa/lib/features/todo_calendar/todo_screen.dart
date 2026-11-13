
import 'package:flutter/material.dart';

import '../../core/services/dataservice.dart';
import '../../core/theme/app_colors.dart';
import 'calendar_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> tasks = [];

  final title = TextEditingController();

  DateTime due = DateTime.now();

  @override
  void initState() {
    super.initState();
    tasks = LocalDataService.list('tasks');
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  Future<void> _editTask({
    Map<String, dynamic>? task,
  }) async {
    title.text = task?['title'] ?? '';
    due = DateTime.tryParse(task?['due'] ?? '') ?? DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            task == null ? 'Add task' : 'Edit task',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: due,
                  );

                  if (picked != null) {
                    setDialogState(() => due = picked);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${due.day}/${due.month}/${due.year}',
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

                final all = LocalDataService.list('tasks');

                if (task == null) {
                  all.add({
                    'id': DateTime.now()
                        .microsecondsSinceEpoch
                        .toString(),
                    'title': title.text.trim(),
                    'due': due.toIso8601String(),
                    'done': false,
                  });
                } else {
                  final index = all.indexWhere(
                    (e) => e['id'] == task['id'],
                  );

                  if (index >= 0) {
                    all[index]['title'] = title.text.trim();
                    all[index]['due'] = due.toIso8601String();
                  }
                }

                await LocalDataService.saveList('tasks', all);

                if (mounted) {
                  setState(
                    () => tasks = LocalDataService.list('tasks'),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((e) => e['done'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do Calendar'),
        actions: [
          IconButton(
            tooltip: 'Calendar view',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CalendarScreen(),
              ),
            ),
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editTask(),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${tasks.length - completed} tasks remaining',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text('$completed / ${tasks.length} completed'),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: tasks.isEmpty ? 0 : completed / tasks.length,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet. Add your first task.',
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final date = DateTime.tryParse(
                        task['due'] ?? '',
                      );

                      return Card(
                        color: AppColors.surface,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task['done'] == true,
                            onChanged: (value) async {
                              task['done'] = value ?? false;

                              await LocalDataService.saveList(
                                'tasks',
                                tasks,
                              );

                              if (mounted) {
                                setState(
                                  () => tasks =
                                      LocalDataService.list('tasks'),
                                );
                              }
                            },
                          ),
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              decoration: task['done'] == true
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            date == null
                                ? ''
                                : 'Due ${date.day}/${date.month}/${date.year}',
                          ),
                          onTap: () => _editTask(task: task),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                            onPressed: () async {
                              await LocalDataService.remove(
                                'tasks',
                                task['id'],
                              );

                              if (mounted) {
                                setState(
                                  () => tasks =
                                      LocalDataService.list('tasks'),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
