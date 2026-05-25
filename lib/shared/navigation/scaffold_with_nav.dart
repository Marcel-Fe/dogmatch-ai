import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Gemeinsames Geruest fuer die fuenf Haupt-Tabs. Die [NavigationBar] wechselt
/// den aktiven Zweig der `StatefulShellRoute`, ohne die anderen Tabs neu
/// aufzubauen - jeder Tab behaelt also seinen eigenen Zustand.
class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const int _assistantTabIndex = 2;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Erneuter Tap auf den aktiven Tab springt zurueck zu dessen Startseite.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnAssistant =
        navigationShell.currentIndex == _assistantTabIndex;
    return Scaffold(
      body: navigationShell,
      floatingActionButton: isOnAssistant
          ? null
          : FloatingActionButton(
              tooltip: 'KI-Berater fragen',
              onPressed: () => _onDestinationSelected(_assistantTabIndex),
              child: const Icon(Icons.smart_toy_rounded),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy_rounded),
            label: 'KI-Berater',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favoriten',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
