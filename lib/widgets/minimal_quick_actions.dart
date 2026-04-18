import 'package:flutter/material.dart';

class MinimalQuickActions extends StatelessWidget {
  final VoidCallback onLogAssessment;
  final VoidCallback onBookTherapy;

  const MinimalQuickActions({
    super.key,
    required this.onLogAssessment,
    required this.onBookTherapy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionItem(
            context,
            Icons.spa_outlined,
            'Book Therapy',
            onBookTherapy,
          ),
          _buildActionItem(
            context,
            Icons.auto_awesome_outlined,
            'AI Coach',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Coach coming soon!')),
              );
            },
          ),
          _buildActionItem(
            context,
            Icons.assignment_outlined,
            'Log Data',
            onLogAssessment,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2B4236).withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(
              icon,
              size: 26,
              color: const Color(0xFF2B4236),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B4236),
            ),
          ),
        ],
      ),
    );
  }
}
