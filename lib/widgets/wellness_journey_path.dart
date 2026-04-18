import 'package:flutter/material.dart';

class WellnessJourneyPath extends StatelessWidget {
  final double height;
  
  const WellnessJourneyPath({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: height,
      child: CustomPaint(
        painter: PathPainter(),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2B4236).withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final double dashHeight = 10;
    final double dashSpace = 8;
    double startY = 0;

    while (startY < size.height) {
      // Draw a simple wavy segment
      final double endY = startY + dashHeight;
      final double offset = (startY / size.height) * 20; // Subtle curve
      
      canvas.drawLine(
        Offset(size.width / 2 + (startY % 40 < 20 ? 5 : -5), startY),
        Offset(size.width / 2 + (endY % 40 < 20 ? 5 : -5), endY),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
