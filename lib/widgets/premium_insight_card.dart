import 'package:flutter/material.dart';
import 'package:ruh_care/models/wellness_data.dart';

class PremiumInsightCard extends StatelessWidget {
  final WellnessData data;

  const PremiumInsightCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildIntelligenceCard(
                'STRESS LEVEL',
                '${data.stressLevel.toInt()}%',
                '↓ 12%',
                const Color(0xFF2B4236).withValues(alpha: 0.05),
                const Color(0xFF2B4236),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildIntelligenceCard(
                'PAIN SENSATION',
                '${data.painLevel.toInt()}%',
                '↑ Spike',
                const Color(0xFFE4E8D8).withValues(alpha: 0.3),
                const Color(0xFF2B4236),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_outlined, size: 16, color: Color(0xFF6B8E67)),
                  const SizedBox(width: 8),
                  Text(
                    'AI CONCIERGE INSIGHT',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: const Color(0xFF6B8E67).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Neck tension is ${data.painLevel > 50 ? 'elevated' : 'improving'}. We recommend focusing on the upper cervical area during your next session.',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                   fontWeight: FontWeight.w500,
                   color: Color(0xFF2B4236),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntelligenceCard(String label, String value, String trend, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: textColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: trend.contains('↓') ? const Color(0xFF6B8E67) : Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
