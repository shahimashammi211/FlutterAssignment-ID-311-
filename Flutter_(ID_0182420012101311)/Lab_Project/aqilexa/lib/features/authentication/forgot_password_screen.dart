import 'package:flutter/material.dart';
import '../../core/services/service2_dart.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/wave_auth_shell.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _done = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );

  Future<void> _resetPassword() async {
    try {
      await LocalAuthService.resetPassword(
        email: _email.text,
        recoveryCode: _code.text,
        newPassword: _password.text,
      );
      if (!mounted) return;
      setState(() => _done = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated. You can sign in now.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WaveAuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(height: 35),
          Text(
            _done ? 'Password Updated' : 'Forgot Password?',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _done
                ? 'Your local password has been changed.'
                : 'Use the recovery code you created during registration. No reset email is sent in Local Mode.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 35),
          if (!_done) ...[
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoration('Registered email', Icons.email_outlined),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              decoration: _decoration('Recovery code', Icons.key_outlined),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: _hidePassword,
              decoration: _decoration('New password', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _hidePassword = !_hidePassword),
                  icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: _decoration('Confirm new password', Icons.lock_reset),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (_password.text.length < 8 || _password.text != _confirm.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords must match and contain at least 8 characters.'),
                      ),
                    );
                    return;
                  }
                  _resetPassword();
                },
                child: const Text('RESET PASSWORD'),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('BACK TO SIGN IN'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
