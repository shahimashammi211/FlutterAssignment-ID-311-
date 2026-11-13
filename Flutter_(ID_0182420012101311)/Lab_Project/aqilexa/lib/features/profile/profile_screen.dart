import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController(text: 'Student');
  final emailController = TextEditingController(text: 'student@email.com');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved for this session.'),
      ),
    );
  }

  void showInformation(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 65,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'AQILEXA Student',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Learn Beyond Limits.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 35),

            _sectionTitle('Personal Information'),

            const SizedBox(height: 15),

            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.white),
              decoration: _decoration('Full Name', Icons.person_outline),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.white),
              decoration: _decoration('Email Address', Icons.email_outlined),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Profile'),
              ),
            ),

            const SizedBox(height: 30),

            _sectionTitle('Account Settings'),
            const SizedBox(height: 12),

            _settingTile(
              Icons.lock_outline,
              'Change Password',
              () => showInformation(
                'Change Password',
                'Password management will be connected with Firebase.',
              ),
            ),
            _settingTile(
              Icons.notifications_outlined,
              'Notifications',
              () => showInformation(
                'Notifications',
                'Notification settings will be available soon.',
              ),
            ),
            _settingTile(
              Icons.privacy_tip_outlined,
              'Privacy Policy',
              () => showInformation(
                'Privacy Policy',
                'Your account and study data will be handled securely.',
              ),
            ),
            _settingTile(
              Icons.info_outline,
              'About AQILEXA',
              () => showInformation(
                'About AQILEXA',
                'AQILEXA helps students organize courses, '
                'analyze exams and improve study productivity.',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showInformation(
                    'Sign Out',
                    'Firebase sign out will be connected later.',
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      labelText: hint,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.silver),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _settingTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.silver),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.white),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}