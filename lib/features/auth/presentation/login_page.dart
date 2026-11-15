import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/env/app_environment.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/widgets/auth_scaffold_layout.dart';
import 'package:smart_drone_inspection/shared/widgets/motion_primitives.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
    this.initialEmail,
    this.bannerMessage,
    this.initialError,
  });

  final String? initialEmail;
  final String? bannerMessage;
  final String? initialError;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  final _otpCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _error;
  String? _infoBanner;
  bool _obscurePassword = true;
  bool _obscureNew = true;
  bool _busy = false;
  String _selectedOtpChannel = 'EMAIL';
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _email.text = widget.initialEmail!;
    }
    _infoBanner = widget.bannerMessage;
    _error = widget.initialError;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    _otpCode.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _error = null;
      _infoBanner = null;
      _busy = true;
    });
    final result = await ref
        .read(authNotifierProvider.notifier)
        .login(email: _email.text.trim(), password: _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case ApiError(:final failure):
        setState(() => _error = describeAuthFailure(context, failure));
      case ApiSuccess(:final data):
        if (data.requiresPasswordChange) {
          final email = data.user?.email;
          if (email != null) _email.text = email;
          _current.text = _password.text;
        } else if (data.requiresOtp) {
          final channels = data.availableOtpChannels;
          _selectedOtpChannel = channels.isNotEmpty ? channels.first : 'EMAIL';
          _otpSent = false;
          _otpCode.clear();
        }
    }
  }

  Future<void> _sendOtp(String challengeToken) async {
    setState(() {
      _error = null;
      _busy = true;
    });
    final res = await ref
        .read(authNotifierProvider.notifier)
        .sendLoginOtp(
          challengeToken: challengeToken,
          channel: _selectedOtpChannel,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (res) {
      case ApiSuccess():
        setState(() => _otpSent = true);
      case ApiError(:final failure):
        setState(() => _error = describeAuthFailure(context, failure));
    }
  }

  Future<void> _verifyOtp(String challengeToken) async {
    if (_otpCode.text.trim().length < 4) {
      setState(() => _error = context.l10n.required);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    final res = await ref
        .read(authNotifierProvider.notifier)
        .verifyLoginOtp(
          challengeToken: challengeToken,
          code: _otpCode.text.trim(),
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (res is ApiError) {
      setState(
        () => _error = describeAuthFailure(context, (res as ApiError).failure),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final authUrl =
        '${AppEnvironment.apiBaseUrl}/auth/oauth2/authorize/google?client_type=mobile';
    final uri = Uri.parse(authUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        setState(() => _error = context.l10n.somethingWentWrong);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = context.l10n.cannotReachServer);
      }
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_next.text != _confirm.text) {
      setState(() => _error = context.l10n.passwordsDoNotMatch);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    final result = await ref
        .read(authNotifierProvider.notifier)
        .completeInitialPasswordSetup(
          email: _email.text.trim(),
          currentPassword: _current.text,
          newPassword: _next.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (result case ApiError(:final failure)) {
      setState(() => _error = describeAuthFailure(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final session = ref.watch(authNotifierProvider).value;
    final needsSetup = session?.requiresPasswordChange == true;
    final needsOtp = session?.requiresOtp == true;

    final title = needsSetup
        ? l10n.setNewPassword
        : needsOtp
        ? l10n.verifyOtp
        : l10n.signIn;

    final subtitle = (!needsSetup && !needsOtp) ? l10n.signInSubtitle : null;

    return AuthScaffoldLayout(
      title: title,
      subtitle: subtitle,
      footer: (!needsSetup && !needsOtp)
          ? Center(
              child: OutlinedButton(
                key: const Key('go-register-btn'),
                onPressed: _busy ? null : () => context.push('/register'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: scheme.surface.withValues(alpha: 0.72),
                  side: BorderSide(color: scheme.outlineVariant),
                ),
                child: Text(l10n.createAccount),
              ),
            )
          : null,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_infoBanner != null) ...[
              AuthStatusBanner(message: _infoBanner!, isError: false),
              const SizedBox(height: 14),
            ],
            if (_error != null) ...[
              AuthStatusBanner(message: _error!, isError: true),
              const SizedBox(height: 14),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(
                  needsSetup
                      ? 'setup'
                      : needsOtp
                      ? 'otp-$_otpSent'
                      : 'login',
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: needsSetup
                      ? _buildPasswordSetupFields(l10n)
                      : needsOtp
                      ? _buildOtpFields(l10n, session!.challengeToken!)
                      : _buildLoginFields(l10n, scheme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLoginFields(dynamic l10n, ColorScheme scheme) {
    return [
      TextFormField(
        key: const Key('login-email-field'),
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: l10n.email,
          prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return l10n.required;
          if (!v.contains('@')) return l10n.invalidEmail;
          return null;
        },
      ),
      const SizedBox(height: 14),
      TextFormField(
        key: const Key('login-password-field'),
        controller: _password,
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _busy ? null : _signIn(),
        decoration: InputDecoration(
          labelText: l10n.password,
          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? l10n.required : null,
      ),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: _busy ? null : () => context.push('/forgot-password'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          ),
          child: Text(l10n.forgotPassword),
        ),
      ),
      const SizedBox(height: 8),
      PrimaryGradientButton(
        key: const Key('login-submit-btn'),
        label: _busy ? l10n.submitting : l10n.signIn,
        busy: _busy,
        onPressed: _busy ? null : _signIn,
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              l10n.or,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
      const SizedBox(height: 18),
      OutlinedButton.icon(
        onPressed: _busy ? null : _signInWithGoogle,
        icon: const GoogleGMark(size: 18),
        label: Text(l10n.signInWithGoogle),
      ),
    ];
  }

  List<Widget> _buildPasswordSetupFields(dynamic l10n) {
    return [
      Text(
        l10n.passwordSetupNotice,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: _next,
        obscureText: _obscureNew,
        decoration: InputDecoration(
          labelText: l10n.newPasswordRequirement,
          prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscureNew = !_obscureNew),
            icon: Icon(
              _obscureNew
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
          ),
        ),
        validator: (v) =>
            (v == null || v.length < 15) ? l10n.minimum15Characters : null,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: _confirm,
        obscureText: _obscureNew,
        decoration: InputDecoration(
          labelText: l10n.confirmNewPassword,
          prefixIcon: const Icon(Icons.verified_user_outlined, size: 20),
        ),
        validator: (v) => (v == null || v.isEmpty) ? l10n.required : null,
      ),
      const SizedBox(height: 20),
      PrimaryGradientButton(
        label: _busy ? l10n.submitting : l10n.setNewPassword,
        busy: _busy,
        onPressed: _busy ? null : _completeSetup,
      ),
    ];
  }

  List<Widget> _buildOtpFields(dynamic l10n, String challengeToken) {
    final channels =
        ref.read(authNotifierProvider).value?.availableOtpChannels ??
        const ['EMAIL'];
    return [
      Text(
        l10n.otpPrompt(_email.text.trim()),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 14),
      if (channels.length > 1) ...[
        DropdownButtonFormField<String>(
          initialValue: _selectedOtpChannel,
          items: [
            for (final c in channels)
              DropdownMenuItem(value: c, child: Text(c)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _selectedOtpChannel = v);
          },
        ),
        const SizedBox(height: 14),
      ],
      if (!_otpSent)
        PrimaryGradientButton(
          label: _busy ? l10n.submitting : l10n.sendOtp,
          busy: _busy,
          onPressed: _busy ? null : () => _sendOtp(challengeToken),
        )
      else ...[
        TextFormField(
          controller: _otpCode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.otpCodeLabel,
            prefixIcon: const Icon(Icons.pin_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryGradientButton(
          label: _busy ? l10n.submitting : l10n.verifyOtp,
          busy: _busy,
          onPressed: _busy ? null : () => _verifyOtp(challengeToken),
        ),
      ],
      const SizedBox(height: 10),
      TextButton(
        onPressed: _busy
            ? null
            : () => ref.read(authNotifierProvider.notifier).invalidateSession(),
        child: Text(l10n.cancel),
      ),
    ];
  }
}
