import 'dart:math';
import 'package:flutter/material.dart';

class InteractiveWellnessCompass extends StatefulWidget {
  final int score;
  final double stress;
  final double pain;

  const InteractiveWellnessCompass({
    super.key,
    required this.score,
    required this.stress,
    required this.pain,
  });

  @override
  State<InteractiveWellnessCompass> createState() => _InteractiveWellnessCompassState();
}

class _InteractiveWellnessCompassState extends State<InteractiveWellnessCompass> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Animated Background Aura
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6B7B3A).withOpacity(0.04 + (0.01 * sin(_controller.value * 2 * pi))),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Main Compass Ring
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E8D8).withOpacity(0.4), width: 1),
              ),
              child: CustomPaint(
                painter: CompassPainter(
                  score: widget.score,
                  stress: widget.stress,
                  pain: widget.pain,
                  rotation: _controller.value * 2 * pi,
                ),
                child: Container(),
              ),
            ),
            
            // Center Info Plate
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7B3A).withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'BALANCE',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                  Text(
                    '${widget.score}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF2D3436),
                      height: 1.0,
                    ),
                  ),
                  const Text(
                    'OPTIMAL',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7B3A),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Intelligence Nodes (Requested replacement)
            Positioned(
              top: 30,
              right: 20,
              child: _buildMetricNode('STRESS', widget.stress, Colors.orangeAccent),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: _buildMetricNode('PAIN', widget.pain, Colors.redAccent),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricNode(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$label ${value.toInt()}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final int score;
  final double stress;
  final double pain;
  final double rotation;

  CompassPainter({
    required this.score,
    required this.stress,
    required this.pain,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    // Background Score Arc
    paint.color = const Color(0xFFE4E8D8).withOpacity(0.5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      0, 2 * pi, false, paint,
    );

    // Dynamic Score Arc
    paint.color = const Color(0xFF6B7B3A);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      -pi / 2,
      (score / 100) * 2 * pi,
      false,
      paint,
    );

    // Static Ticks
    paint.strokeWidth = 1;
    paint.color = const Color(0xFF6B7B3A).withOpacity(0.2);
    for (var i = 0; i < 60; i++) {
      final angle = (i * (360 / 60)) * pi / 180;
      final length = i % 5 == 0 ? 12.0 : 6.0;
      final p1 = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
      final p2 = Offset(center.dx + (radius - length) * cos(angle), center.dy + (radius - length) * sin(angle));
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
