
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/wave_auth_shell.dart';
import '../authentication/login_screen.dart';
import '../authentication/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => WaveAuthShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 105),
            const Icon(
              Icons.nightlight_round,
              size: 42,
              color: AppColors.silver,
            ),
            const SizedBox(height: 18),
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your future is being written by what you do today',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 125),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                ),
                child: const Text('SIGN UP'),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                ),
                child: const Text('SIGN IN'),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      );
}
