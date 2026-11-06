import 'package:flutter/material.dart';

import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/note_screen.dart';
import '../screens/upload_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/forgot_password_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String notes = '/notes';
  static const String upload = '/upload';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    notes: (context) => const NoteScreen(),
    upload: (context) => const UploadScreen(),
    profile: (context) => const ProfileScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
  };
}