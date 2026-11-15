import 'package:flutter/material.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';
import 'package:smart_drone_inspection/shared/widgets/motion_primitives.dart';
import 'package:smart_drone_inspection/shared/widgets/sdi_logo_mark.dart';

/// Shared atmospheric header + elevated form sheet scaffold for Customer auth screens.
class AuthScaffoldLayout extends StatelessWidget {
  const AuthScaffoldLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.onBack,
    this.stepIndex,
    this.stepLabels,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final VoidCallback? onBack;
  final int? stepIndex;
  final List<String>? stepLabels;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.34, 1.0],
                  colors: isDark
                      ? [
                          const Color(0xFF0F1E3A),
                          AppTheme.darkCanvas,
                          AppTheme.darkCanvas,
                        ]
                      : [
                          const Color(0xFFE7F1FE),
                          const Color(0xFFF3F8FE),
                          AppTheme.lightCanvas,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -60,
            child: IgnorePointer(
              child: CustomPaint(
                size: const Size(280, 280),
                painter: _AuthOrbitBackdropPainter(
                  primary: scheme.primary.withValues(
                    alpha: isDark ? 0.14 : 0.08,
                  ),
                  teal: AppTheme.irisTeal.withValues(
                    alpha: isDark ? 0.12 : 0.07,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 36,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (onBack != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Material(
                                    color: scheme.surface.withValues(
                                      alpha: isDark ? 0.85 : 0.9,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: scheme.outlineVariant,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: onBack,
                                      borderRadius: BorderRadius.circular(12),
                                      child: const SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: Icon(
                                          Icons.arrow_back_rounded,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            MotionEntrance(
                              offset: const Offset(0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: scheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: scheme.outlineVariant,
                                          ),
                                          boxShadow: AppTheme.cardShadow(
                                            context,
                                          ),
                                        ),
                                        child: const Center(
                                          child: SdiLogoMark(size: 32),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.appName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: -0.35,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 9,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: scheme.primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                l10n.customerPortalSubtitle,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      scheme.onPrimaryContainer,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  if (subtitle != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      subtitle!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (stepLabels != null &&
                                stepIndex != null &&
                                stepLabels!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              MotionEntrance(
                                delay: const Duration(milliseconds: 50),
                                offset: const Offset(0, 8),
                                child: _AuthStepBar(
                                  currentStep: stepIndex!,
                                  labels: stepLabels!,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            MotionEntrance(
                              delay: const Duration(milliseconds: 80),
                              offset: const Offset(0, 14),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: scheme.surface,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: scheme.outlineVariant,
                                  ),
                                  boxShadow: AppTheme.cardShadow(context),
                                ),
                                padding: const EdgeInsets.all(22),
                                child: child,
                              ),
                            ),
                            if (footer != null) ...[
                              const SizedBox(height: 16),
                              MotionEntrance(
                                delay: const Duration(milliseconds: 120),
                                offset: const Offset(0, 8),
                                child: footer!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthStepBar extends StatelessWidget {
  const _AuthStepBar({required this.currentStep, required this.labels});

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (int i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: i == currentStep
                    ? scheme.primaryContainer
                    : i < currentStep
                    ? const Color(0xFFECFDF5)
                    : scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: i == currentStep
                      ? scheme.primary.withValues(alpha: 0.45)
                      : i < currentStep
                      ? AppTheme.success.withValues(alpha: 0.35)
                      : scheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: i < currentStep
                          ? AppTheme.success
                          : i == currentStep
                          ? scheme.primary
                          : scheme.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: i < currentStep
                          ? const Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: Colors.white,
                            )
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: i == currentStep
                                    ? Colors.white
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: i == currentStep
                            ? scheme.onPrimaryContainer
                            : i < currentStep
                            ? AppTheme.success
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Reusable alert banner styled with crisp status colors on auth screens.
class AuthStatusBanner extends StatelessWidget {
  const AuthStatusBanner({
    super.key,
    required this.message,
    required this.isError,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isError ? scheme.error : AppTheme.success;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthOrbitBackdropPainter extends CustomPainter {
  _AuthOrbitBackdropPainter({required this.primary, required this.teal});

  final Color primary;
  final Color teal;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.62, size.height * 0.38);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = primary;

    canvas.drawCircle(center, 72, ringPaint);
    canvas.drawCircle(
      center,
      114,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = teal,
    );
    canvas.drawCircle(
      center,
      154,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = primary.withValues(alpha: primary.a * 0.6),
    );
  }

  @override
  bool shouldRepaint(covariant _AuthOrbitBackdropPainter oldDelegate) =>
      oldDelegate.primary != primary || oldDelegate.teal != teal;
}
