import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

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
                'Courses',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Learn the art of healing',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 24),
              _buildCourseCard(
                'Basic Hijama Course',
                'Learn the fundamentals of Hijama cupping therapy, safe practices, and patient care.',
                'Dr. Ahmed',
                '4 Weeks',
                '₹3,500',
              ),
              const SizedBox(height: 16),
              _buildCourseCard(
                'Advanced Cupping Therapy',
                'Master advanced cupping techniques including fire cupping and combined therapies.',
                'Dr. Fatima',
                '6 Weeks',
                '₹5,000',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCourseCard(
    String title,
    String description,
    String instructor,
    String duration,
    String price,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F0EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B7B3A).withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school_rounded, color: Color(0xFF6B7B3A), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2D3436)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Color(0xFF8A8A8A), height: 1.4),
          ),
          const SizedBox(height: 14),
          // Details row
          Row(
            children: [
              _infoChip(Icons.person_outline, instructor),
              const SizedBox(width: 12),
              _infoChip(Icons.access_time, duration),
              const Spacer(),
              Text(
                price,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF6B7B3A)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6B7B3A)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Enroll Now',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7B3A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF8A8A8A)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A))),
      ],
    );
  }
}
