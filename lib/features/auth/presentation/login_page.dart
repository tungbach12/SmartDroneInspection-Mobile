import 'package:flutter/material.dart';

/// Placeholder login page — full form lands with the auth feature.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: const Center(child: Text('Login form goes here')),
    );
  }
}
