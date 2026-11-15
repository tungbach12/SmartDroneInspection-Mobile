import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/data/auth_repository.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/widgets/auth_scaffold_layout.dart';
import 'package:smart_drone_inspection/shared/widgets/motion_primitives.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _otp = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirm = TextEditingController();

  String? _challengeToken;
  String? _error;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _otp.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _error = null;
      _busy = true;
    });
    final res = await ref
        .read(authRepositoryProvider)
        .sendPasswordResetOtp(email: _email.text.trim());
    if (!mounted) return;
    setState(() => _busy = false);
    switch (res) {
      case ApiSuccess(:final data):
        setState(() => _challengeToken = data.challengeToken);
      case ApiError(:final failure):
        setState(() => _error = describeAuthFailure(context, failure));
    }
  }

  Future<void> _confirmReset() async {
    if (_challengeToken == null || !_formKey.currentState!.validate()) return;
    if (_newPassword.text != _confirm.text) {
      setState(() => _error = context.l10n.passwordsDoNotMatch);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    final res = await ref
        .read(authRepositoryProvider)
        .confirmPasswordReset(
          email: _email.text.trim(),
          challengeToken: _challengeToken!,
          code: _otp.text.trim(),
          newPassword: _newPassword.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (res) {
      case ApiSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.passwordResetSuccess)),
        );
        context.go('/login');
      case ApiError(:final failure):
        setState(() => _error = describeAuthFailure(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasChallenge = _challengeToken != null;

    return AuthScaffoldLayout(
      title: l10n.resetPassword,
      subtitle: hasChallenge
          ? l10n.otpPrompt(_email.text.trim())
          : l10n.authResetSubtitle,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/login');
        }
      },
      stepIndex: hasChallenge ? 1 : 0,
      stepLabels: [l10n.stepResetRequest, l10n.stepResetVerify],
      footer: Center(
        child: TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
          child: Text(l10n.alreadyHaveAccount),
        ),
      ),
      child: Form(
        key: _formKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: Column(
            key: ValueKey(hasChallenge ? 'reset-confirm' : 'reset-request'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                AuthStatusBanner(message: _error!, isError: true),
                const SizedBox(height: 14),
              ],
              TextFormField(
                controller: _email,
                enabled: !hasChallenge,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                ),
                validator: (v) =>
                    (v == null || !v.contains('@')) ? l10n.invalidEmail : null,
              ),
              const SizedBox(height: 16),
              if (!hasChallenge)
                PrimaryGradientButton(
                  label: _busy ? l10n.submitting : l10n.sendResetOtp,
                  busy: _busy,
                  onPressed: _busy ? null : _sendOtp,
                )
              else ...[
                TextFormField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.otpCodeLabel,
                    prefixIcon: const Icon(Icons.pin_outlined, size: 20),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _newPassword,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: l10n.newPasswordRequirement,
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 15)
                      ? l10n.minimum15Characters
                      : null,
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _confirm,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: l10n.confirmNewPassword,
                    prefixIcon: const Icon(
                      Icons.verified_user_outlined,
                      size: 20,
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 18),
                PrimaryGradientButton(
                  label: _busy ? l10n.submitting : l10n.resetPassword,
                  busy: _busy,
                  onPressed: _busy ? null : _confirmReset,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
