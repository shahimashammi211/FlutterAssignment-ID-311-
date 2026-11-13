import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:aqilexa/app.dart';
import 'package:aqilexa/core/services/database.dart';

void main() {
  late Directory testDirectory;

  setUpAll(() async {
    testDirectory =
        await Directory.systemTemp.createTemp('aqilexa_widget_test_');
    await LocalDatabase.initializeAt(testDirectory.path);
  });

  tearDownAll(() async {
    await LocalDatabase.box.close();
    await testDirectory.delete(recursive: true);
  });

  testWidgets('AQILEXA opens the welcome screen when signed out',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AqilexaApp());
    await tester.pump();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('SIGN IN'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
  });
}
