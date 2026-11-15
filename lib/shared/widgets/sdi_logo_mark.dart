import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Vector brand mark #06 (4-Blade Optical Iris) matching Frontend NextAdminLogoMark.
class SdiLogoMark extends StatelessWidget {
  const SdiLogoMark({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _SdiIrisLogoPainter()),
    );
  }
}

/// Branded horizontal lockup showing the 4-Blade Optical Iris mark + SDI wordmark.
class SdiBrandLockup extends StatelessWidget {
  const SdiBrandLockup({super.key, this.logoSize = 36, this.subtitle});

  final double logoSize;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SdiLogoMark(size: logoSize),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SDI',
              style: TextStyle(
                fontSize: logoSize * 0.56,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: scheme.onSurface,
                height: 1.05,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: scheme.primary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SdiIrisLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 48.0;
    final scaleY = size.height / 48.0;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final gradientShader = ui.Gradient.linear(
      const Offset(8, 6),
      const Offset(40, 42),
      const [Color(0xFF3B82F6), Color(0xFF2DD4BF)],
    );

    const p0 = Offset(9.97, 12.72);
    const p1 = Offset(33.6, 8.78);
    const p2 = Offset(29.88, 18.0);
    const p3 = Offset(19.83, 16.71);

    Offset rot90(Offset pt, int turns) {
      var cur = pt;
      for (var i = 0; i < turns; i++) {
        cur = Offset(48 - cur.dy, cur.dx);
      }
      return cur;
    }

    final fills = [
      Paint()..color = const Color(0xFF3B82F6),
      Paint()..color = const Color(0xFF0EA5E9),
      Paint()..shader = gradientShader,
      Paint()..color = const Color(0xFF2B84EB),
    ];

    for (var k = 0; k < 4; k++) {
      final a = rot90(p0, k);
      final b = rot90(p1, k);
      final c = rot90(p2, k);
      final d = rot90(p3, k);
      final blade = Path()
        ..moveTo(a.dx, a.dy)
        ..arcToPoint(b, radius: const Radius.circular(18))
        ..lineTo(c.dx, c.dy)
        ..arcToPoint(d, radius: const Radius.circular(8.4), clockwise: false)
        ..close();
      canvas.drawPath(blade, fills[k]);
    }

    // Center iris ring + white pupil
    canvas.drawCircle(
      const Offset(24, 24),
      5.6,
      Paint()..shader = gradientShader,
    );
    canvas.drawCircle(const Offset(24, 24), 2.4, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
