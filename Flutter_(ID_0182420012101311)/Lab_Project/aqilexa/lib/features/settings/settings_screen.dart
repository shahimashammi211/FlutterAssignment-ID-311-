
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/services/service2_dart.dart';
import '../../core/services/dataservice.dart';
import '../../core/theme/app_colors.dart';
import '../welcome/welcome_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final u = LocalAuthService.currentUser;
    final notebooks = LocalDataService.list('notebooks');
    final tasks = LocalDataService.list('tasks');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.surface,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                backgroundImage: u?.photoBase64 == null
                    ? null
                    : MemoryImage(base64Decode(u!.photoBase64!)),
                child: u?.photoBase64 == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(u?.fullName ?? 'AQILEXA User'),
              subtitle: Text(u?.email ?? ''),
              trailing: const Icon(Icons.person_outline),
            ),
          ),

          _heading('Preferences'),
          _tile(
            Icons.dark_mode_outlined,
            'Dark Mode',
            'Display preference • coming later',
          ),
          _tile(
            Icons.notifications_outlined,
            'Notifications',
            'Study reminders • coming later',
          ),
          _tile(
            Icons.fingerprint,
            'Biometric Unlock',
            'Future feature',
          ),
          _tile(
            Icons.cloud_outlined,
            'Cloud Sync',
            'Supabase integration • currently disabled',
          ),

          _heading('App Settings'),
          _tile(
            Icons.language,
            'Language',
            'English • display only',
          ),
          _tile(
            Icons.public,
            'Region',
            'Bangladesh • display only',
          ),
          _tile(
            Icons.storage,
            'Storage',
            '${notebooks.length} notebooks • ${tasks.length} tasks',
          ),
          _tile(
            Icons.info_outline,
            'About AQILEXA',
            'Version 1.0.0',
          ),

          _heading('Security & Privacy'),
          _tile(
            Icons.privacy_tip_outlined,
            'Privacy & Security',
            'Information',
          ),
          _tile(
            Icons.key_outlined,
            'Change Password',
            'Use Forgot Password from Login for local recovery',
          ),

          _heading('Account'),
          Card(
            color: AppColors.surface,
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: AppColors.error,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                final yes = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Logout?'),
                    content: const Text(
                      'Your saved notebooks and tasks will remain on this browser.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (yes == true) {
                  await LocalAuthService.signOut();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WelcomeScreen(),
                      ),
                      (r) => false,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _heading(String s) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
        child: Text(
          s,
          style: const TextStyle(
            color: AppColors.silver,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _tile(
    IconData i,
    String t,
    String sub,
  ) =>
      Card(
        color: AppColors.surface,
        child: ListTile(
          leading: Icon(
            i,
            color: AppColors.silver,
          ),
          title: Text(t),
          subtitle: Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
          onTap: () => {},
        ),
      );
}
