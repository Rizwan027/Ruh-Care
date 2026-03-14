import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Top bar: avatar + app name + notification
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF1F3EC),
                      border: Border.all(color: const Color(0xFFE4E8D8), width: 1.5),
                    ),
                    child: const Icon(Icons.person, size: 22, color: Color(0xFF6B7B3A)),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Ruh-Care',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF8F8F6),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: const Icon(Icons.notifications_outlined, size: 22, color: Color(0xFF2D3436)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Welcome text
              const Text(
                'Welcome back, Sarah',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your journey to wellness starts here.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8A8A8A),
                ),
              ),

              const SizedBox(height: 22),

              // Upcoming Session Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B7B3A), Color(0xFF8A9A5B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B7B3A).withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Upcoming Session',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Cognitive Therapy',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.white.withAlpha(200)),
                              const SizedBox(width: 6),
                              Text(
                                'Tomorrow, 10:00 AM',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withAlpha(220),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 26),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // QUICK ACTIONS
              const Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Color(0xFF8A8A8A),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildQuickAction(Icons.spa_outlined, 'Book\nTherapy', () {}),
                  const SizedBox(width: 24),
                  _buildQuickAction(Icons.storefront_outlined, 'Shop\nProducts', () {}),
                  const SizedBox(width: 24),
                  _buildQuickAction(Icons.menu_book_outlined, 'View\nCourses', () {}),
                ],
              ),

              const SizedBox(height: 30),

              // Recommended Therapies
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Therapies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7B3A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTherapyCard(
                      'assets/images/therapy_meditation.png',
                      'Mindfulness Meditation',
                      'Find inner peace and clarity today.',
                      4.9,
                      120,
                    ),
                    const SizedBox(width: 16),
                    _buildTherapyCard(
                      'assets/images/therapy_cupping.png',
                      'Group Cupping',
                      'Shared experience for healing.',
                      4.8,
                      85,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Essential Wellness (Products)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Essential Wellness',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Shop More',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7B3A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/product_oil.png',
                      'Lavender Calm Oil',
                      '\$24.00',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/product_wellness.png',
                      'Reflective Journal',
                      '\$18.50',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8F8F6),
              border: Border.all(color: const Color(0xFFE8E8E4), width: 1.5),
            ),
            child: Icon(icon, size: 26, color: const Color(0xFF6B7B3A)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3436),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTherapyCard(
    String imagePath,
    String title,
    String description,
    double rating,
    int reviews,
  ) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3436),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A8A8A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFFB800)),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews reviews)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildProductCard(String imagePath, String name, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7B3A),
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
