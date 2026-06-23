import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/providers/auth_provider.dart';
import 'package:pos_app/screens/dashboard/dashboard_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Placeholder untuk halaman-halaman
  final List<Widget> _pages = [
    const DashboardScreen(),
    const Center(child: Text('Kasir')),
    const Center(child: Text('Produk')),
    const Center(child: Text('Transaksi')),
    const Center(child: Text('Pengaturan')),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale_rounded), label: 'Kasir'),
    NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: 'Produk'),
    NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Transaksi'),
    NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Settings'),
  ];

  final List<NavigationRailDestination> _railDestinations = const [
    NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: Text('Dashboard')),
    NavigationRailDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale_rounded), label: Text('Kasir')),
    NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: Text('Produk')),
    NavigationRailDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: Text('Transaksi')),
    NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    // Mendeteksi lebar layar untuk responsive layout
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    
    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: _railDestinations,
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthProvider>().logout();
                      },
                    ),
                  ),
                ),
              ),
            ),
            
          if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
          
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _destinations,
            )
          : null,
    );
  }
}
