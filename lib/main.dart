import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/router/app_router.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';

void main() {
  runApp(const ProviderScope(child: SmartDroneInspectionApp()));
}

class SmartDroneInspectionApp extends ConsumerWidget {
  const SmartDroneInspectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SmartDroneInspection',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => _HydrationGate(child ?? const SizedBox()),
    );
  }
}

/// Keeps the splash visible until the first session hydration resolves,
/// so the router never flashes the wrong route during startup.
class _HydrationGate extends ConsumerWidget {
  const _HydrationGate(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydrating = ref.watch(
      authNotifierProvider.select((value) => value.isLoading),
    );
    if (hydrating) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return child;
  }
}
