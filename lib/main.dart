import 'package:flutter/material.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
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
    final localeAsync = ref.watch(localeNotifierProvider);
    final locale = localeAsync.value ?? const Locale('en');

    return MaterialApp.router(
      title: lookupAppLocalizations(locale).appName,
      locale: locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => _HydrationGate(
        child ?? const SizedBox(),
        localeLoading: localeAsync.isLoading,
      ),
    );
  }
}

/// Keeps the splash visible until the first session hydration resolves,
/// so the router never flashes the wrong route during startup.
class _HydrationGate extends ConsumerWidget {
  const _HydrationGate(this.child, {required this.localeLoading});

  final Widget child;
  final bool localeLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydrating = ref.watch(
      authNotifierProvider.select((value) => value.isLoading),
    );
    if (hydrating || localeLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return child;
  }
}
