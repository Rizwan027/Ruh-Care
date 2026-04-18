import 'package:flutter/material.dart';

class HealingJourneyStrip extends StatelessWidget {
  const HealingJourneyStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2B4236).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2B4236).withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'YOUR HEALING JOURNEY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Color(0xFF6B8E67),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.trending_down, size: 14, color: Color(0xFF6B8E67)),
                  const SizedBox(width: 4),
                  Text(
                    'PAIN ↓ 22%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B8E67).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSessionNode('S1', true, true),
              _buildProgressLine(true),
              _buildSessionNode('S2', true, true),
              _buildProgressLine(false),
              _buildSessionNode('S3', false, false),
              _buildProgressLine(false),
              _buildSessionNode('S4', false, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionNode(String label, bool isCompleted, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF2B4236) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? const Color(0xFF2B4236) : const Color(0xFFE4E8D8),
              width: 2,
            ),
            boxShadow: isCurrent ? [
              BoxShadow(
                color: const Color(0xFF2B4236).withValues(alpha: 0.3),
                blurRadius: 10,
              )
            ] : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? const Color(0xFF2B4236) : const Color(0xFF8A8A8A),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2B4236) : const Color(0xFFE4E8D8),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
