
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/dataservice.dart';
import '../../core/theme/app_colors.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  Timer? timer;

  int selected = 25, remaining = 1500, completed = 0, total = 0;

  bool running = false, isBreak = false, longBreak = false;

  final custom = TextEditingController();

  @override
  void initState() {
    super.initState();

    final sessions = LocalDataService.list('focus');

    completed = sessions.length;

    total = sessions.fold<int>(
      0,
      (s, e) => s + (e['seconds'] as int? ?? 0),
    );
  }

  void start() {
    if (running || remaining <= 0) return;

    setState(() => running = true);

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        if (!mounted) {
          t.cancel();
          return;
        }

        if (remaining <= 1) {
          t.cancel();

          final completedFocus = !isBreak;

          setState(() {
            remaining = 0;
            running = false;

            if (isBreak) {
              isBreak = false;
              longBreak = false;
              remaining = selected * 60;
            } else {
              completed++;
              total += selected * 60;
              isBreak = true;
              longBreak = completed % 4 == 0;
              remaining = (longBreak ? 15 : 5) * 60;
            }
          });

          if (completedFocus) {
            LocalDataService.add(
              'focus',
              {
                'id': DateTime.now().microsecondsSinceEpoch.toString(),
                'seconds': selected * 60,
                'completedAt': DateTime.now().toIso8601String(),
              },
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                completedFocus
                    ? 'Focus complete. Take a break.'
                    : 'Break complete. Ready to focus?',
              ),
            ),
          );

          return;
        }

        setState(() => remaining--);
      },
    );
  }

  void pause() {
    timer?.cancel();
    setState(() => running = false);
  }

  void reset() {
    timer?.cancel();

    setState(() {
      running = false;
      isBreak = false;
      longBreak = false;
      remaining = selected * 60;
    });
  }

  void setDuration(int m) {
    if (running) return;

    timer?.cancel();

    setState(() {
      selected = m;
      remaining = m * 60;
      isBreak = false;
      longBreak = false;
    });
  }

  String get clock =>
      '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';

  String get totalText =>
      '${total ~/ 3600}h ${(total % 3600) ~/ 60}m';

  @override
  void dispose() {
    timer?.cancel();
    custom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Focus Timer'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                isBreak
                    ? (longBreak ? 'Long Break' : 'Short Break')
                    : 'Stay Focused',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 8,
                  ),
                ),
                child: Center(
                  child: Text(
                    clock,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Wrap(
                spacing: 8,
                children: [
                  for (final m in [25, 50, 60])
                    ChoiceChip(
                      label: Text('$m min'),
                      selected: selected == m,
                      onSelected: (_) => setDuration(m),
                    ),
                  ActionChip(
                    label: const Text('Custom'),
                    onPressed: () {
                      custom.clear();

                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Custom minutes'),
                          content: TextField(
                            controller: custom,
                            keyboardType: TextInputType.number,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                final v = int.tryParse(custom.text);

                                if (v != null && v > 0 && v <= 180) {
                                  setDuration(v);
                                }

                                Navigator.pop(c);
                              },
                              child: const Text('Set'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: running ? pause : start,
                    icon: Icon(
                      running ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(running ? 'Pause' : 'Start'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat('Sessions', '$completed'),
                  _stat('Focus time', totalText),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _stat(String l, String v) => Column(
        children: [
          Text(
            v,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            l,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
}
