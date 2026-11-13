
import 'package:flutter/material.dart';

import '../../core/services/dataservice.dart';
import '../../core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final all = LocalDataService.list('tasks');

    final dayTasks = all.where((task) {
      final date = DateTime.tryParse(task['due'] ?? '');

      return date != null &&
          date.year == selected.year &&
          date.month == selected.month &&
          date.day == selected.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: selected,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            onDateChanged: (date) => setState(() => selected = date),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tasks on ${selected.day}/${selected.month}/${selected.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: dayTasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks scheduled for this date.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView(
                    children: dayTasks
                        .map(
                          (task) => ListTile(
                            leading: Icon(
                              task['done'] == true
                                  ? Icons.check_circle
                                  : Icons.event_note,
                            ),
                            title: Text(task['title'] ?? ''),
                            subtitle: Text(
                              task['done'] == true
                                  ? 'Completed'
                                  : 'Pending',
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
