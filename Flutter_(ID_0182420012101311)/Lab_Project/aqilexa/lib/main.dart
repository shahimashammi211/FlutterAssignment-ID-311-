import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/database.dart';
import 'core/services/optionalservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabase.initialize();


  try {
    await SupabaseOptionalService.initializeIfEnabled();
  } catch (error, stackTrace) {
    debugPrint('Supabase initialization failed; continuing in local mode: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  runApp(const AqilexaApp());
}
