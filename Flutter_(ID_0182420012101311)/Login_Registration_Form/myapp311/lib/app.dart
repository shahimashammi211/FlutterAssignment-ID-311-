import 'package:flutter/material.dart';

import 'auth/auth_gate.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp311',
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}