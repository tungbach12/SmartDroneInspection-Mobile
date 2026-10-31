import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/env/app_environment.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _signInWithGoogle() async {
    final authUrl =
        '${AppEnvironment.apiBaseUrl}/auth/oauth2/authorize/google?client_type=mobile';
    final uri = Uri.parse(authUrl);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        setState(() => _error = context.l10n.somethingWentWrong);
      }
    } catch (_) {
      setState(() => _error = context.l10n.cannotReachServer);
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_next.text != _confirm.text) {
      setState(() => _error = context.l10n.passwordsDoNotMatch);
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
    UnauthorizedFailure() => context.l10n.invalidCredentials,
    ValidationFailure(:final errors) =>
      errors.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
    ServerFailure(:final detail) => detail ?? context.l10n.serverError,
    NetworkFailure() => context.l10n.cannotReachServer,
    NotFoundFailure() => context.l10n.notFoundError,
    UnknownFailure(:final message) => message,
  };

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authNotifierProvider).value;
    final requiresChange = session?.requiresPasswordChange == true;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.signIn)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (requiresChange) ...[
                Text(
                  context.l10n.passwordSetupNotice,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  enabled: false,
                  decoration: InputDecoration(labelText: context.l10n.email),
                ),
                TextFormField(
                  controller: _current,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.currentPassword,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? context.l10n.required : null,
                ),
                TextFormField(
                  controller: _next,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.newPasswordRequirement,
                  ),
                  validator: (v) => (v == null || v.length < 15)
                      ? context.l10n.minimum15Characters
                      : null,
                ),
                TextFormField(
                  controller: _confirm,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.confirmNewPassword,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? context.l10n.required : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _completeSetup,
                  child: Text(context.l10n.setNewPassword),
                ),
              ] else ...[
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: context.l10n.email),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? context.l10n.required : null,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: context.l10n.password),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? context.l10n.required : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _signIn,
                  child: Text(context.l10n.signIn),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.l10n.or.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: Text(context.l10n.signInWithGoogle),
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
