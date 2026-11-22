import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'favourites_screen.dart';
import 'home_screen.dart';
import 'menus_screen.dart';
import 'profile_screen.dart';
import 'transport_screen.dart';

/// Bottom-navigation container shown after login.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _transportIndex = 1;
  static const _menusIndex = 2;

  late int _index = widget.initialIndex;

  // Demo role until real authentication decides who is an admin.
  bool _isAdmin = true;

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: IndexedStack(
          index: _index,
          children: [
            HomeScreen(
              userName: _isAdmin ? 'Esra' : 'Tülin',
              onSeeAllDepartures: () => _select(_transportIndex),
              onSeeFullMenus: () => _select(_menusIndex),
            ),
            const TransportScreen(),
            const MenusScreen(),
            const FavouritesScreen(),
            ProfileScreen(
              isAdmin: _isAdmin,
              onToggleRole: () => setState(() => _isAdmin = !_isAdmin),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            selectedIcon: Icon(Icons.directions_bus),
            label: 'Ulaşım',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menüler',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
