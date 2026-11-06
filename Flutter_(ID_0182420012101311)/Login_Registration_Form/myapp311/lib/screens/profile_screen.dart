
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../services/profile_service.dart';
import '../services/upload_service.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import 'upload_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService profileService = ProfileService();
  final UploadService uploadService = UploadService();

  final nameController = TextEditingController();

  Map<String, dynamic>? profile;
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await profileService.getProfile();

      if (!mounted) return;

      setState(() {
        profile = result;
        nameController.text =
            result?['name']?.toString() ??
            AuthService().currentUser?.userMetadata?['name']?.toString() ??
            '';
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile loading failed: $error')),
      );
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await profileService.updateProfile(
        name: nameController.text.trim(),
      );

      await loadProfile();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    final imageUrl = profile?['avatar_url']?.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    CircleAvatar(
                      radius: 65,
                      backgroundColor: AppColors.lightTeal,
                      backgroundImage:
                          imageUrl != null && imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                      child: imageUrl == null || imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: AppColors.primary,
                            )
                          : null,
                    ),

                    const SizedBox(height: 15),

                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UploadScreen(),
                          ),
                        );

                        await loadProfile();
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Change Profile Image'),
                    ),

                    const SizedBox(height: 25),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Full Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      initialValue: user?.email ?? '',
                      readOnly: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomButton(
                      text: 'Save Changes',
                      isLoading: isSaving,
                      onPressed: saveProfile,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Your profile information is stored securely.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grayText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
