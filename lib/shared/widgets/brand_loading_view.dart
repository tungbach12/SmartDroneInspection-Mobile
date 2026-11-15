import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_drone_inspection/shared/widgets/sdi_logo_mark.dart';

/// Full-screen branded loading state displaying the animated 4-Blade Optical Iris.
class BrandLoadingView extends StatefulWidget {
  const BrandLoadingView({super.key, this.message, this.showBrandTitle = true});

  final String? message;
  final bool showBrandTitle;

  @override
  State<BrandLoadingView> createState() => _BrandLoadingViewState();
}

class _BrandLoadingViewState extends State<BrandLoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.14),
          radius: 0.95,
          colors: isDark
              ? const [Color(0xFF13223F), Color(0xFF0B1120)]
              : const [Color(0xFFEFF6FF), Color(0xFFF8FAFC)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedIrisOrbit(controller: _controller, size: 96),
              if (widget.showBrandTitle) ...[
                const SizedBox(height: 18),
                Text(
                  'SDI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: scheme.onSurface,
                  ),
                ),
              ],
              if (widget.message != null && widget.message!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  widget.message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _ShimmerProgressPill(controller: _controller),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact animated 4-Blade Optical Iris spinner for in-page async loading states.
class IrisLoadingSpinner extends StatefulWidget {
  const IrisLoadingSpinner({super.key, this.size = 52});

  final double size;

  @override
  State<IrisLoadingSpinner> createState() => _IrisLoadingSpinnerState();
}

class _IrisLoadingSpinnerState extends State<IrisLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: _AnimatedIrisOrbit(controller: _controller, size: widget.size),
    );
  }
}

class _AnimatedIrisOrbit extends StatelessWidget {
  const _AnimatedIrisOrbit({required this.controller, required this.size});

  final AnimationController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coreSize = size * 0.74;
    final markSize = size * 0.45;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;
        final wave = math.sin(t * math.pi * 2);
        final haloScale = 0.94 + 0.08 * (0.5 + 0.5 * wave);
        final logoScale = 0.96 + 0.06 * (0.5 + 0.5 * wave);
        final logoAngle = 0.14 * wave;

        return SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: haloScale,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF3B82F6).withValues(alpha: 0.22),
                        const Color(0xFF2DD4BF).withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Transform.rotate(
                angle: t * math.pi * 2,
                child: CustomPaint(
                  size: Size.square(size),
                  painter: _OrbitalArcPainter(
                    strokeWidth: size >= 72 ? 3.2 : 2.4,
                  ),
                ),
              ),
              Container(
                width: coreSize,
                height: coreSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF0F172A).withValues(alpha: 0.94)
                      : Colors.white.withValues(alpha: 0.96),
                  border: Border.all(
                    color: const Color(0xFF94A3B8)
                        .withValues(alpha: isDark ? 0.22 : 0.26),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A)
                          .withValues(alpha: isDark ? 0.35 : 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: logoAngle,
                  child: Transform.scale(scale: logoScale, child: child),
                ),
              ),
            ],
          ),
        );
      },
      child: SdiLogoMark(size: markSize),
    );
  }
}

class _OrbitalArcPainter extends CustomPainter {
  const _OrbitalArcPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final deflated = rect.deflate(strokeWidth / 2);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.10);
    canvas.drawOval(deflated, trackPaint);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [
          Color(0x003B82F6),
          Color(0xFF3B82F6),
          Color(0xFF0EA5E9),
          Color(0xFF2DD4BF),
        ],
        stops: [0.0, 0.35, 0.68, 1.0],
      ).createShader(rect);

    canvas.drawArc(deflated, 0, math.pi * 1.25, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitalArcPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth;
}

class _ShimmerProgressPill extends StatelessWidget {
  const _ShimmerProgressPill({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    const trackWidth = 140.0;
    const thumbWidth = 62.0;

    return Container(
      width: trackWidth,
      height: 3.5,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFF3B82F6).withValues(alpha: 0.14),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final dx = -thumbWidth + (trackWidth + thumbWidth) * controller.value;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: thumbWidth,
            height: 3.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF0EA5E9),
                  Color(0xFF2DD4BF),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
