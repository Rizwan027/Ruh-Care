import 'package:flutter/material.dart';

class PainMap extends StatelessWidget {
  final String selectedArea;
  final ValueChanged<String> onAreaSelected;

  const PainMap({
    super.key,
    required this.selectedArea,
    required this.onAreaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Tap to update your pain map",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8A8A8A),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 320,
          height: 380,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE4E8D8)),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Wrapping image and dots in a sized container matching the cropped image aspect ratio
              SizedBox(
                width: 253,
                height: 350,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background Cropped Human Outline Image
                    Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/images/human_body_outline.png',
                        width: 253,
                        height: 350,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person_outline,
                            size: 250,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),

                    // Touch Targets (Center of image is width 253/2 = 126.5)
                    _buildTarget(area: 'Neck', top: 45, left: 126),
                    _buildTarget(area: 'Shoulders', top: 70, left: 126),
                    _buildTarget(area: 'Upper Back', top: 105, left: 126),
                    _buildTarget(area: 'Lower Back', top: 160, left: 126),
                    _buildTarget(area: 'Legs', top: 250, left: 126),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Fallback or "Full Body" option
        GestureDetector(
          onTap: () => onAreaSelected('Full Body'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: selectedArea == 'Full Body'
                  ? const Color(0xFF6B7B3A)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6B7B3A)),
            ),
            child: Text(
              'Select Full Body',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedArea == 'Full Body'
                    ? Colors.white
                    : const Color(0xFF6B7B3A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTarget({
    required String area,
    required double top,
    required double left,
  }) {
    final isSelected = selectedArea == area;
    final dotSize = 28.0;

    return Positioned(
      top: top - (dotSize / 2),
      left: left - (dotSize / 2),
      child: GestureDetector(
        onTap: () => onAreaSelected(area),
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6B7B3A).withAlpha(217)
                    : const Color(0xFF6B7B3A).withAlpha(38),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6B7B3A).withAlpha(153),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              area,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF6B7B3A)
                    : const Color(0xFF8A8A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
