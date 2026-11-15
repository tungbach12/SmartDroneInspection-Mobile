import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';
import 'package:smart_drone_inspection/features/auth/data/auth_repository.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/widgets/auth_scaffold_layout.dart';
import 'package:smart_drone_inspection/shared/widgets/motion_primitives.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _otpCode = TextEditingController();

  bool _obscurePassword = true;
  bool _sendingOtp = false;
  bool _submitting = false;
  String? _challengeToken;
  String? _error;
  String? _reviewMessage;
  int _countdown = 0;
  int _passwordLen = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      if (_password.text.length != _passwordLen) {
        setState(() => _passwordLen = _password.text.length);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    _otpCode.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown <= 1) {
        timer.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown -= 1);
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _confirm.text) {
      setState(() => _error = context.l10n.passwordsDoNotMatch);
      return;
    }
    setState(() {
      _error = null;
      _sendingOtp = true;
    });
    final res = await ref
        .read(authRepositoryProvider)
        .sendRegistrationOtp(
          email: _email.text.trim(),
          phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        );
    if (!mounted) return;
    setState(() => _sendingOtp = false);
    switch (res) {
      case ApiSuccess(:final data):
        setState(() => _challengeToken = data.challengeToken);
        _startCountdown();
      case ApiError(:final failure):
        setState(() => _error = describeAuthFailure(context, failure));
    }
  }

  Future<void> _submitRegistration() async {
    if (_challengeToken == null) return;
    if (_otpCode.text.trim().length < 4) {
      setState(() => _error = context.l10n.required);
      return;
    }
    setState(() {
      _error = null;
      _submitting = true;
    });
    final res = await ref
        .read(authRepositoryProvider)
        .registerCustomer(
          fullName: _fullName.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          otpChallengeToken: _challengeToken!,
          otpCode: _otpCode.text.trim(),
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (res) {
      case ApiSuccess(:final data):
        if (data.isPendingAirspaceReview) {
          setState(
            () => _reviewMessage =
                data.reviewMessage ?? context.l10n.pendingAirspaceReviewNotice,
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.registrationSuccess)),
        );
        context.go(
          '/login',
          extra: {
            'email': _email.text.trim(),
            'banner': context.l10n.registrationSuccess,
          },
        );
      case ApiError(:final failure):
        setState(() => _error = describeAuthFailure(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final awaitingOtp = _challengeToken != null;

    return AuthScaffoldLayout(
      title: l10n.createAccount,
      subtitle: l10n.authRegisterSubtitle,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/login');
        }
      },
      stepIndex: _reviewMessage != null ? 2 : (awaitingOtp ? 1 : 0),
      stepLabels: [l10n.stepAccountDetails, l10n.stepEmailVerification],
      footer: _reviewMessage == null
          ? Center(
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
            )
          : null,
      child: Form(
        key: _formKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _reviewMessage != null
              ? Column(
                  key: const ValueKey('review'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.hourglass_top_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(_reviewMessage!)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryGradientButton(
                      label: l10n.signIn,
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                )
              : Column(
                  key: ValueKey(awaitingOtp ? 'step-otp' : 'step-form'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      AuthStatusBanner(message: _error!, isError: true),
                      const SizedBox(height: 14),
                    ],
                    if (!awaitingOtp) ...[
                      TextFormField(
                        key: const Key('register-fullname-field'),
                        controller: _fullName,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.required
                            : null,
                      ),
                      const SizedBox(height: 13),
                      TextFormField(
                        key: const Key('register-email-field'),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            size: 20,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.required;
                          }
                          if (!v.contains('@')) return l10n.invalidEmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 13),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumberOptional,
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      TextFormField(
                        key: const Key('register-password-field'),
                        controller: _password,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.newPasswordRequirement,
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
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
                      const SizedBox(height: 8),
                      _PasswordLengthBar(
                        length: _passwordLen,
                        label: l10n.passwordCharsProgress(_passwordLen),
                      ),
                      const SizedBox(height: 13),
                      TextFormField(
                        key: const Key('register-confirm-field'),
                        controller: _confirm,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
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
                      const SizedBox(height: 20),
                      PrimaryGradientButton(
                        key: const Key('register-send-otp-btn'),
                        label: _sendingOtp ? l10n.submitting : l10n.sendOtp,
                        busy: _sendingOtp,
                        onPressed: _sendingOtp ? null : _sendOtp,
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: scheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.mark_email_read_outlined,
                                color: scheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.otpPrompt(_email.text.trim()),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('register-otp-field'),
                        controller: _otpCode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.otpCodeLabel,
                          prefixIcon: const Icon(Icons.pin_outlined, size: 20),
                        ),
                      ),
                      const SizedBox(height: 18),
                      PrimaryGradientButton(
                        key: const Key('register-submit-btn'),
                        label: _submitting ? l10n.submitting : l10n.verifyOtp,
                        busy: _submitting,
                        onPressed: _submitting ? null : _submitRegistration,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _countdown > 0 || _sendingOtp
                                ? null
                                : _sendOtp,
                            child: Text(
                              _countdown > 0
                                  ? l10n.otpResendCountdown(_countdown)
                                  : l10n.resendOtp,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                setState(() => _challengeToken = null),
                            child: Text(l10n.cancel),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _PasswordLengthBar extends StatelessWidget {
  const _PasswordLengthBar({required this.length, required this.label});

  final int length;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final met = length >= 15;
    final progress = (length / 15).clamp(0.0, 1.0);
    final toneColor = met
        ? AppTheme.success
        : (length >= 8 ? AppTheme.skyAccent : scheme.outline);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: scheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(toneColor),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (met) ...[
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppTheme.success,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: met ? AppTheme.success : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
