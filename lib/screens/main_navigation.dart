import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'activity_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Data satu menu navigasi.
class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _NavItem(this.label, this.icon, this.selectedIcon);
}

/// Kerangka utama aplikasi: menampung 4 halaman dan menu navigasinya.
/// - Layar sempit (Android)  -> Bottom Navigation Bar
/// - Layar lebar (Web)       -> Menu di samping (NavigationRail)
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Urutan halaman harus sama dengan urutan _items.
  static const List<Widget> _pages = [
    HomeScreen(),
    ActivityScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  static const List<_NavItem> _items = [
    _NavItem('Beranda', Icons.home_outlined, Icons.home),
    _NavItem('Aktivitas', Icons.event_note_outlined, Icons.event_note),
    _NavItem('Favorit', Icons.star_border, Icons.star),
    _NavItem('Profil', Icons.person_outline, Icons.person),
  ];

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // IndexedStack menjaga halaman tetap "hidup" saat pindah tab,
    // sehingga posisi scroll dan isi input tidak hilang.
    final content = IndexedStack(index: _selectedIndex, children: _pages);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >= AppConstants.wideScreenBreakpoint;

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onSelect,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Icon(Icons.school, size: 32),
                  ),
                  destinations: [
                    for (final item in _items)
                      NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                // Konten dibatasi lebarnya agar tidak terlalu melebar.
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppConstants.maxContentWidth,
                      ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onSelect,
            destinations: [
              for (final item in _items)
                NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ),
            ],
          ),
        );
      },
    );
  }
}
