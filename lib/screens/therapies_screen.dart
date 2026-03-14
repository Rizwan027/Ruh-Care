import 'package:flutter/material.dart';

class TherapiesScreen extends StatelessWidget {
  const TherapiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Therapies',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Discover our healing treatments',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildTherapyTile('Dry Cupping', 'Suction-based therapy for pain relief', Icons.spa_rounded, '30 min'),
                    _buildTherapyTile('Wet Cupping (Hijama)', 'Traditional prophetic medicine therapy', Icons.water_drop_rounded, '45 min'),
                    _buildTherapyTile('Fire Cupping', 'Heat-based cupping for deep healing', Icons.local_fire_department_rounded, '30 min'),
                    _buildTherapyTile('Leech Therapy', 'Bio-therapy for blood purification', Icons.healing_rounded, '40 min'),
                    _buildTherapyTile('Acupuncture', 'Needle therapy for energy balance', Icons.settings_accessibility_rounded, '50 min'),
                    _buildTherapyTile('Kasa Thali Therapy', 'Bronze plate healing technique', Icons.circle_outlined, '35 min'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTherapyTile(String name, String subtitle, IconData icon, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6B7B3A).withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF6B7B3A), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2D3436)),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7B3A).withAlpha(15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              duration,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7B3A)),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 22),
        ],
      ),
    );
  }
}
