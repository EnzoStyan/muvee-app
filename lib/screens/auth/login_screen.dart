// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Halaman Login Muvee',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}