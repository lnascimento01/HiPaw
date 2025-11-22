import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsPatternBackground extends StatelessWidget {
  const HiPawsPatternBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HiPawsColors.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PatternPainter(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFEAE8F5);

    final pawPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: 10))
      ..addOval(Rect.fromCircle(center: const Offset(10, -14), radius: 4))
      ..addOval(Rect.fromCircle(center: const Offset(-10, -14), radius: 4))
      ..addOval(Rect.fromCircle(center: const Offset(8, -4), radius: 4))
      ..addOval(Rect.fromCircle(center: const Offset(-8, -4), radius: 4));

    for (double y = -40; y < size.height + 80; y += 140) {
      for (double x = -30; x < size.width + 60; x += 140) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawPath(pawPath, paint);
        canvas.restore();
      }
    }

    for (double y = 40; y < size.height + 80; y += 160) {
      for (double x = 40; x < size.width + 60; x += 160) {
        final rect = Rect.fromCenter(center: Offset(x, y), width: 34, height: 12);
        final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
        canvas.drawRRect(rRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
