import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/authentication/auth_gate.dart';

class AqilexaApp extends StatelessWidget {
  const AqilexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQILEXA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}