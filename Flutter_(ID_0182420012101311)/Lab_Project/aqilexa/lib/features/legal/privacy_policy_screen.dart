import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Privacy & Local Data')),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Text(
            'AQILEXA currently stores account details and study content locally '
                      ),
        ),
      );
}
