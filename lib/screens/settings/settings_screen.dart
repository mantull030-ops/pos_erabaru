import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<AuthProvider>().userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profil Pengguna', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Nama'),
                    subtitle: Text(userProfile?.name ?? '-'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('ID Toko'),
                    subtitle: Text(userProfile?.storeId ?? '-'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Peran (Role)'),
                    subtitle: Text(userProfile?.role ?? '-'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Keluar (Logout)'),
          )
        ],
      ),
    );
  }
}
