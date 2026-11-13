
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/services/service2_dart.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/wave_auth_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _recoveryCodeController = TextEditingController();

  String? _photoBase64;

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _acceptedPrivacy = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _recoveryCodeController.dispose();
    super.dispose();
  }

  // Profile photo picker compatible with file_picker 13.x
  Future<void> _pickPhoto() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        throw Exception('Selected image is empty.');
      }

      if (bytes.length > 3 * 1024 * 1024) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image smaller than 3 MB.'),
          ),
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        _photoBase64 = base64Encode(bytes);
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo selection failed: $error'),
        ),
      );
    }
  }

  void _updateFullName() {
    _fullNameController.text =
        '${_firstNameController.text.trim()} '
        '${_lastNameController.text.trim()}'.trim();
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the privacy notice.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await LocalAuthService.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        recoveryCode: _recoveryCodeController.text.trim(),
        photoBase64: _photoBase64,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Account Created Successfully'),
            content: const Text(
              'Your AQILEXA local account has been created. '
              'Please return to the Login screen and sign in '
              'using your email and password.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WaveAuthShell(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),

            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),

            const SizedBox(height: 10),

            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Create your AQILEXA account and start your journey.',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 25),

            // Profile photo
            Center(
              child: InkWell(
                onTap: _pickPhoto,
                borderRadius: BorderRadius.circular(60),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.surface,
                  backgroundImage: _photoBase64 == null
                      ? null
                      : MemoryImage(
                          base64Decode(_photoBase64!),
                        ),
                  child: _photoBase64 == null
                      ? const Icon(
                          Icons.add_a_photo_outlined,
                          size: 30,
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 9),

            const Center(
              child: Text(
                'Add Profile Photo (Optional)',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // First Name
            TextFormField(
              controller: _firstNameController,
              onChanged: (_) => _updateFullName(),
              decoration: _inputDecoration(
                'First Name',
                Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your first name.';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Last Name
            TextFormField(
              controller: _lastNameController,
              onChanged: (_) => _updateFullName(),
              decoration: _inputDecoration(
                'Last Name',
                Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your last name.';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Automatic Full Name
            TextFormField(
              controller: _fullNameController,
              readOnly: true,
              decoration: _inputDecoration(
                'Full Name (Automatic)',
                Icons.badge_outlined,
              ),
            ),

            const SizedBox(height: 14),

            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                'Email Address',
                Icons.email_outlined,
              ),
              validator: (value) {
                final email = value?.trim() ?? '';

                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(email)) {
                  return 'Please enter a valid email address.';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: _inputDecoration(
                'Password (Minimum 8 Characters)',
                Icons.lock_outline,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Password must contain at least 8 characters.';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _hideConfirmPassword,
              decoration: _inputDecoration(
                'Confirm Password',
                Icons.lock_outline,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _hideConfirmPassword =
                          !_hideConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _hideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Recovery Code
            TextFormField(
              controller: _recoveryCodeController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                '6-Digit Recovery Code',
                Icons.key_outlined,
              ),
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
                  return 'Enter a 6-digit recovery code.';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            CheckboxListTile(
              value: _acceptedPrivacy,
              onChanged: (value) {
                setState(() {
                  _acceptedPrivacy = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'I agree to the local data and privacy notice.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createAccount,
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Already have an account? Sign In',
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
