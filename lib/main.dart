import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/router/app_router.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';

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
    );
  }
}
