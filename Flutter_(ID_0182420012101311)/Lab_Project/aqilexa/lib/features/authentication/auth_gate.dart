import 'package:flutter/material.dart';
import '../../core/services/service2_dart.dart';
import '../dashboard/dashboard_screen.dart';
import '../welcome/welcome_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => FutureBuilder<LocalUser?>(
    future: LocalAuthService.restoreSession(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return snapshot.data == null ? const WelcomeScreen() : const DashboardScreen();
    },
  );
}
