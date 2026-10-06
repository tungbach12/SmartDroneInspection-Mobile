import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    final result = await ref
        .read(authNotifierProvider.notifier)
        .login(email: _email.text.trim(), password: _password.text);
    switch (result) {
      case ApiError(:final failure):
        setState(() => _error = _describe(failure));
      case ApiSuccess(:final data):
        if (data.requiresPasswordChange) {
          final email = data.user?.email;
          if (email != null) _email.text = email;
          _current.text = _password.text;
        }
        break; // router redirect handles navigation
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_next.text != _confirm.text) {
      setState(() => _error = 'New passwords do not match.');
      return;
    }
    setState(() => _error = null);
    final result = await ref
        .read(authNotifierProvider.notifier)
        .completeInitialPasswordSetup(
          email: _email.text.trim(),
          currentPassword: _current.text,
          newPassword: _next.text,
        );
    switch (result) {
      case ApiError(:final failure):
        setState(() => _error = _describe(failure));
      case ApiSuccess():
        break;
    }
  }

  String _describe(ApiFailure f) => switch (f) {
    UnauthorizedFailure() => 'Invalid credentials.',
    ValidationFailure(:final errors) =>
      errors.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
    ServerFailure(:final detail) => detail ?? 'Server error.',
    NetworkFailure() => 'Cannot reach the server.',
    NotFoundFailure() => 'Not found.',
    UnknownFailure(:final message) => message,
  };

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authNotifierProvider).value;
    final requiresChange = session?.requiresPasswordChange == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (requiresChange) ...[
                const Text(
                  'You must set a new password before continuing.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _current,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current password',
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: _next,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New password (15+ characters)',
                  ),
                  validator: (v) => (v == null || v.length < 15)
                      ? 'Minimum 15 characters'
                      : null,
                ),
                TextFormField(
                  controller: _confirm,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm new password'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _completeSetup,
                  child: const Text('Set new password'),
                ),
              ] else ...[
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _signIn,
                  child: const Text('Sign in'),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
