
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  static Future<void> initialize() async {}

  static void show({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
      ),
    );
  }
}
