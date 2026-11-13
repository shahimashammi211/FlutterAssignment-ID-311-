
import 'package:flutter/material.dart';

import '../../core/services/service2_dart.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/wave_auth_shell.dart';
import '../dashboard/dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _hide = true, _remember = true, _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _busy = true);

    try {
      await LocalAuthService.signIn(
        email: _email.text,
        password: _password.text,
        rememberMe: _remember,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
        (r) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  InputDecoration _dec(
    String label,
    IconData icon, {
    Widget? suffix,
  }) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) => WaveAuthShell(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 34),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Study now be proud later',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 42),

              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec('Email', Icons.email_outlined),
                validator: (v) =>
                    v == null || !v.contains('@')
                        ? 'Enter a valid email'
                        : null,
              ),

              const SizedBox(height: 18),
              TextFormField(
                controller: _password,
                obscureText: _hide,
                decoration: _dec(
                  'Password',
                  Icons.lock_outline,
                  suffix: IconButton(
                    onPressed: () => setState(() => _hide = !_hide),
                    icon: Icon(
                      _hide
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty
                        ? 'Enter your password'
                        : null,
              ),

              Row(
                children: [
                  Checkbox(
                    value: _remember,
                    onChanged: (v) =>
                        setState(() => _remember = v ?? false),
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _busy ? null : _login,
                  child: _busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('SIGN IN'),
                ),
              ),

              const SizedBox(height: 22),
              const Center(
                child: Text(
                  'Or continue with',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _social(Icons.g_mobiledata, 'Google'),
                  const SizedBox(width: 14),
                  _social(Icons.code, 'GitHub'),
                  const SizedBox(width: 14),
                  _social(Icons.facebook, 'Facebook'),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    ),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _social(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.silver.withValues(alpha: .25),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
}
