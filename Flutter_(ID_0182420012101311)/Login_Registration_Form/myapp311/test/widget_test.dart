import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aqilexa/widgets/loading_widget.dart';
import 'package:aqilexa/widgets/empty_state.dart';

void main() {
  group('MyApp311 Widget Tests', () {
    testWidgets('LoadingWidget displays loading message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(
              message: 'Loading MyApp311...',
            ),
          ),
        ),
      );

      expect(find.text('Loading MyApp311...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('EmptyState displays title and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Notes Found',
              message: 'Create your first note.',
            ),
          ),
        ),
      );

      expect(find.text('No Notes Found'), findsOneWidget);
      expect(find.text('Create your first note.'), findsOneWidget);
    });

    testWidgets('EmptyState displays default content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(),
          ),
        ),
      );

      expect(find.text('Nothing here yet'), findsOneWidget);
    });
  });
}