import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/providers/auth_provider.dart';
import 'package:pos_app/screens/auth/login_screen.dart';
import 'package:pos_app/screens/dashboard/main_navigation.dart';
import 'package:pos_app/screens/dashboard/dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Tampilkan loading jika sedang auth check
    if (authProvider.isLoading && !authProvider.isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Arahkan ke dashboard jika sudah login
    if (authProvider.isAuthenticated) {
      return const MainNavigation();
    }

    // Tampilkan login jika belum login
    return const LoginScreen();
  }
}

