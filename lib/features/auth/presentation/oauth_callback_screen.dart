import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/brand_loading_view.dart';

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
  ConsumerState<OAuthCallbackScreen> createState() =>
      _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  Future<void> _process() async {
    if (widget.error != null) {
      if (mounted) {
        context.go('/login', extra: {'error': widget.error});
      }
      return;
    }
    if (widget.accessToken != null && widget.refreshToken != null) {
      final result = await ref
          .read(authNotifierProvider.notifier)
          .handleOAuthCallback(
            accessToken: widget.accessToken!,
            refreshToken: widget.refreshToken!,
          );
      if (!mounted) return;
      switch (result) {
        case ApiSuccess(:final data) when data.isAuthenticated:
          context.go('/home');
        case ApiError(:final failure):
          context.go(
            '/login',
            extra: {'error': describeAuthFailure(context, failure)},
          );
        default:
          context.go('/login');
      }
    } else {
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BrandLoadingView(message: 'Customer Portal'));
  }
}
