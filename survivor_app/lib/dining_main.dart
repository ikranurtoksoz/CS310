import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

import 'screens/favourites_screen.dart';
import 'screens/menus_screen.dart';

void main() => runApp(const DiningDevApp());

class DiningDevApp extends StatefulWidget {
  const DiningDevApp({super.key});

  @override
  State<DiningDevApp> createState() => _DiningDevAppState();
}

class _DiningDevAppState extends State<DiningDevApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUrvivor',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: IndexedStack(
          index: _index,
          children: const [MenusScreen(), FavouritesScreen()],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.restaurant_menu), label: 'Menus'),
            NavigationDestination(icon: Icon(Icons.star), label: 'Favs'),
          ],
        ),
      ),
    );
  }
}
