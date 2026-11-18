import 'package:flutter/material.dart';
import 'screens/transport_screen.dart';

void main() => runApp(const TransportTestApp());

class TransportTestApp extends StatelessWidget {
  const TransportTestApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SUrvivor - Transport Test',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    home: const TransportScreen(),
  );
}
