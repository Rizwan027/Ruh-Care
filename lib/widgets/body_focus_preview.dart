import 'package:flutter/material.dart';

class BodyFocusPreview extends StatefulWidget {
  final String tensionArea;

  const BodyFocusPreview({super.key, required this.tensionArea});

  @override
  State<BodyFocusPreview> createState() => _BodyFocusPreviewState();
}

class _BodyFocusPreviewState extends State<BodyFocusPreview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getPoint(String area) {
    switch (area.toLowerCase()) {
      case 'neck': return const Offset(80, 50);
      case 'shoulders': return const Offset(80, 75);
      case 'upper back': return const Offset(80, 100);
      case 'lower back': return const Offset(80, 150);
      default: return const Offset(80, 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B8E67).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.tensionArea.toUpperCase()} • HIGH INTENSITY',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6B8E67),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your next session will prioritize this tension zone.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF2B4236),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Flexible(
                        child: Text(
                          'View detailed pain map',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B8E67),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF6B8E67),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/human_body_outline.png',
                  height: 160,
                  opacity: const AlwaysStoppedAnimation(0.4),
                ),
                if (widget.tensionArea.isNotEmpty)
                  Positioned(
                    left: _getPoint(widget.tensionArea).dx,
                    top: _getPoint(widget.tensionArea).dy,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: 12 + (8 * _controller.value),
                          height: 12 + (8 * _controller.value),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B8E67).withValues(alpha: 0.4 - (0.3 * _controller.value)),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6B8E67),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
