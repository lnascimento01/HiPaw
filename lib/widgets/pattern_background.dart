import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
    const pawSize = 20.0;
    const boneSize = 32.0;
    final paint = Paint()..color = AppColors.softLilac.withOpacity(0.9);

    final pawPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: pawSize / 2))
      ..addOval(Rect.fromCircle(center: const Offset(8, -10), radius: pawSize / 5))
      ..addOval(Rect.fromCircle(center: const Offset(-8, -10), radius: pawSize / 5))
      ..addOval(Rect.fromCircle(center: const Offset(6, -2), radius: pawSize / 5))
      ..addOval(Rect.fromCircle(center: const Offset(-6, -2), radius: pawSize / 5));

    for (final position in _patternPositions(size, 120)) {
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.drawPath(pawPath, paint);
      canvas.restore();
    }

    for (final position in _patternPositions(size, 200, offset: const Offset(40, 80))) {
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(-0.3);
      final rect = Rect.fromCenter(center: Offset.zero, width: boneSize, height: pawSize);
      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
      canvas.drawRRect(rRect, paint);
      canvas.restore();
    }
  }

  Iterable<Offset> _patternPositions(Size size, double spacing, {Offset offset = Offset.zero}) sync* {
    for (double y = offset.dy; y < size.height + spacing; y += spacing) {
      for (double x = offset.dx; x < size.width + spacing; x += spacing) {
        yield Offset(x, y);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
