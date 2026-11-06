import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/supabase_config.dart';
import 'screens/setup_required_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      publishableKey: SupabaseConfig.supabasePublishableKey,
    );

    runApp(const MyApp());
  } else {
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SetupRequiredScreen(),
      ),
    );
  }
}