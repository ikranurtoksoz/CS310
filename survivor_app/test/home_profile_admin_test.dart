import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survivor_app/screens/main_shell.dart';
import 'package:survivor_app/theme/app_theme.dart';

Widget _app() => MaterialApp(
  theme: AppTheme.lightTheme,
  routes: {'/welcome': (_) => const Scaffold(body: Text('Welcome page'))},
  home: const MainShell(),
);

void main() {
  testWidgets('Home tab shows greeting, departures and today\'s menus', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    expect(find.text('Today at campus'), findsOneWidget);
    expect(find.text('KM18 · FROM SABANCI'), findsOneWidget);
    expect(find.text('See all departures', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Admin flow: validation errors on empty save', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Role: admin'), findsOneWidget);

    await tester.tap(find.text('Admin: update data'));
    await tester.pumpAndSettle();
    expect(find.text('Timetable entry'), findsOneWidget);

    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsWidgets);
  });

  testWidgets('Standard profile hides admin entries', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    // Tapping the avatar toggles the demo role.
    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();
    expect(find.text('Admin: update data'), findsNothing);
    expect(find.text('Clear cached data'), findsNothing);
    expect(find.text('Role: admin'), findsNothing);
  });

  testWidgets('Log out returns to the welcome page', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome page'), findsOneWidget);
  });
}
