import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';

class OAuthCallbackScreen extends ConsumerStatefulWidget {
  const OAuthCallbackScreen({
    super.key,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? error;

  @override
  ConsumerState<OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  Future<void> _process() async {
    if (widget.error != null) {
      if (mounted) context.go('/login');
      return;
    }
    if (widget.accessToken != null && widget.refreshToken != null) {
      await ref.read(authNotifierProvider.notifier).handleOAuthCallback(
            accessToken: widget.accessToken!,
            refreshToken: widget.refreshToken!,
          );
      if (mounted) context.go('/home');
    } else {
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
