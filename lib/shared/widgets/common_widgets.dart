import 'package:flutter/material.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';
import 'package:smart_drone_inspection/shared/widgets/brand_loading_view.dart';

class CenteredSpinner extends StatelessWidget {
  const CenteredSpinner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IrisLoadingSpinner(size: 38),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 28,
                color: scheme.error,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? hint;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.12),
                    scheme.secondary.withValues(alpha: 0.08),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Icon(icon, size: 30, color: scheme.primary),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (hint != null) ...[
              const SizedBox(height: 6),
              Text(
                hint!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 18), action!],
          ],
        ),
      ),
    );
  }
}

enum StatusTone { neutral, primary, success, warning, danger }

(Color bg, Color fg) statusColorsForTone(
  BuildContext context,
  StatusTone tone,
) {
  final scheme = Theme.of(context).colorScheme;
  final isDark = scheme.brightness == Brightness.dark;

  return switch (tone) {
    StatusTone.primary => (
      isDark ? const Color(0xFF172554) : const Color(0xFFEFF6FF),
      isDark ? const Color(0xFF60A5FA) : AppTheme.primary,
    ),
    StatusTone.success => (
      isDark ? const Color(0xFF062E1F) : const Color(0xFFECFDF5),
      isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
    ),
    StatusTone.warning => (
      isDark ? const Color(0xFF332208) : const Color(0xFFFFFBEB),
      isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
    ),
    StatusTone.danger => (
      isDark ? const Color(0xFF351316) : const Color(0xFFFEF2F2),
      isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
    ),
    StatusTone.neutral => (
      scheme.surfaceContainerHigh,
      scheme.onSurfaceVariant,
    ),
  };
}

/// Compact capsule status pill aligned across mobile portal surfaces.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
    this.showDot = false,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = statusColorsForTone(context, tone);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 5),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tinted leading glyph badge used on dashboard rows, lists, and settings groups.
class LeadingGlyphBadge extends StatelessWidget {
  const LeadingGlyphBadge({
    super.key,
    required this.icon,
    this.tone = StatusTone.primary,
    this.size = 40,
  });

  final IconData icon;
  final StatusTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = statusColorsForTone(context, tone);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Icon(icon, size: size * 0.5, color: fg),
    );
  }
}

StatusTone statusToneForCode(String? code) =>
    switch ((code ?? '').toUpperCase()) {
      'ACTIVE' ||
      'PAID' ||
      'PUBLISHED' ||
      'COMPLETED' ||
      'ASSIGNED' ||
      'ACCEPTED' ||
      'LOW' => StatusTone.success,
      'IN_PROGRESS' ||
      'UNDER_REVIEW' ||
      'FIELD_COMPLETED' ||
      'CONTRACT_SIGNED' ||
      'SUBMITTED' => StatusTone.primary,
      'QUOTED' ||
      'PAYMENT_DUE' ||
      'PENDING_REVIEW' ||
      'PENDING' ||
      'OPEN' ||
      'MEDIUM' ||
      'RETURNED' => StatusTone.warning,
      'REJECTED' ||
      'CANCELLED' ||
      'ABORTED' ||
      'CRITICAL' ||
      'HIGH' => StatusTone.danger,
      _ => StatusTone.neutral,
    };
