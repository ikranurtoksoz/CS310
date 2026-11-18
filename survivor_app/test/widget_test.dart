
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survivor_app/main.dart';

void main() {
  testWidgets(
    'SUrvivor app starts successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SurvivorApp());

      expect(
        find.byType(MaterialApp),
        findsOneWidget,
      );

      // Splash screen waits for 2 seconds.
      await tester.pump(
        const Duration(seconds: 3),
      );

      // Complete the navigation animation.
      await tester.pumpAndSettle();

      expect(
        find.text('Welcome to SUrvivor!'),
        findsOneWidget,
      );
    },
  );
}
