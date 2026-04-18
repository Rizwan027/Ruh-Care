import 'package:flutter/material.dart';
import 'package:ruh_care/models/wellness_data.dart';
import 'package:ruh_care/screens/assessment_screen.dart';

class SmartWellnessInsightCard extends StatelessWidget {
  final WellnessData? data;

  const SmartWellnessInsightCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF6B7B3A).withAlpha(25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7B3A).withAlpha(20),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF6B7B3A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Wellness Insight',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      'Last Session: ${data!.lastSession.isNotEmpty ? data!.lastSession : 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_note, color: Color(0xFF6B7B3A)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AssessmentScreen()),
                  );
                },
                tooltip: 'Update Assessment',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Stress Level',
                  '${data!.stressLevel.toInt()}/10',
                  Icons.psychology,
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFEEEEEE)),
              Expanded(
                child: _buildStatItem(
                  'Pain Level',
                  '${data!.painLevel.toInt()}/10',
                  Icons.healing,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF6B7B3A).withAlpha(25), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6B7B3A).withAlpha(51)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Color(0xFF6B7B3A),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Suggestion',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A5529),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  data!.suggestion.isNotEmpty
                      ? data!.suggestion
                      : 'Take a moment to breathe and stretch.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2D3436),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8A8A8A)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A8A)),
        ),
      ],
    );
  }
}
