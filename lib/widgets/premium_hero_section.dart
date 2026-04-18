import 'package:flutter/material.dart';
import 'package:ruh_care/models/wellness_data.dart';
import 'package:ruh_care/screens/notifications_screen.dart';

class PremiumHeroSection extends StatelessWidget {
  final String userName;
  final WellnessData? wellnessData;

  const PremiumHeroSection({
    super.key,
    required this.userName,
    this.wellnessData,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F3EC), // Creamy background from logo
      ),
      child: Stack(
        children: [
          // Background "Aura" - subtle and large
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2B4236).withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Row
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Buttons on the sides
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildProfileButton(context),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildNotificationButton(context),
                      ),
                      
                      // Centered Text
                      const Text(
                        'RUH CARE',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Magazine Style Greeting
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF6B8E67),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userName.split(' ').first,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w200,
                              height: 0.9,
                              color: Color(0xFF2B4236), // New Deep Green
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Subtle Streak Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2B4236).withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Text('⚡', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              '3 DAY RITUAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: const Color(0xFF6B8E67).withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: const Icon(Icons.person_outline, size: 20, color: Color(0xFF2B4236)),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: const Icon(Icons.notifications_none, size: 20, color: Color(0xFF2B4236)),
      ),
    );
  }
}
