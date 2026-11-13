
import 'package:flutter/material.dart';

import '../../core/services/service2_dart.dart';
import '../../core/theme/app_colors.dart';
import '../notebook/notebook_screen.dart';
import '../todo_calendar/todo_screen.dart';
import '../focus_timer/focus_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalAuthService.currentUser;

    final cards = [
      (
        'Notebook',
        'Create and organize your notes',
        Icons.menu_book_rounded,
        const NotebookScreen(),
      ),
      (
        'To-do Calendar',
        'Plan tasks and deadlines',
        Icons.calendar_month_rounded,
        const TodoScreen(),
      ),
      (
        'Focus Timer',
        'Build focused study sessions',
        Icons.timer_rounded,
        const FocusScreen(),
      ),
      (
        'Settings',
        'Manage your account and app',
        Icons.settings_rounded,
        const SettingsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AQILEXA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Welcome, ${user?.firstName ?? 'Student'}',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Study now be proud later',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Your Workspace',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.silver,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, i) {
                  final c = cards[i];

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => c.$4,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: .25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            c.$3,
                            size: 34,
                            color: AppColors.silver,
                          ),
                          const SizedBox(height: 17),
                          Text(
                            c.$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            c.$2,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'AQILEXA • Your study companion',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
