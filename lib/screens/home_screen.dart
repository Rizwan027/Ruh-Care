import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruh_care/models/booking.dart';
import 'package:ruh_care/models/therapy.dart';
import 'package:ruh_care/services/booking_service.dart';
import 'package:ruh_care/services/therapy_service.dart';
import 'package:ruh_care/services/user_service.dart';
import 'package:ruh_care/screens/main_navigation.dart';
import 'package:ruh_care/screens/notifications_screen.dart';
import 'package:ruh_care/widgets/premium_hero_section.dart';
import 'package:ruh_care/widgets/premium_insight_card.dart';
import 'package:ruh_care/widgets/premium_upcoming_session.dart';
import 'package:ruh_care/widgets/body_focus_preview.dart';
import 'package:ruh_care/widgets/minimal_quick_actions.dart';
import 'package:ruh_care/widgets/premium_log_data_card.dart';
import 'package:ruh_care/widgets/wellness_journey_path.dart';
import 'package:ruh_care/widgets/healing_journey_strip.dart';
import 'package:ruh_care/models/wellness_data.dart';
import 'package:ruh_care/services/wellness_service.dart';
import 'package:ruh_care/screens/assessment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BookingService _bookingService = BookingService();
  final TherapyService _therapyService = TherapyService();
  final UserService _userService = UserService();
  final WellnessService _wellnessService = WellnessService();

  late User? _user;
  String _displayName = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final profile = await _userService.getUserProfile();
    if (mounted) {
      setState(() {
        _displayName = _userService.getUserName(profile, _user);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Visual Journey Path (Background)
            Positioned(
              top: 500,
              left: 30,
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  children: [
                    WellnessJourneyPath(height: 300),
                    const SizedBox(height: 200),
                    WellnessJourneyPath(height: 400),
                  ],
                ),
              ),
            ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isLoading
                    ? const SizedBox(
                        height: 400,
                        child: Center(child: CircularProgressIndicator(color: Color(0xFF2B4236))),
                      )
                    : StreamBuilder<WellnessData?>(
                        stream: _wellnessService.getLatestWellnessData(),
                        builder: (context, snapshot) {
                          final wellnessData = snapshot.data;
                          return Column(
                            children: [
                              PremiumHeroSection(
                                userName: _displayName,
                                wellnessData: wellnessData,
                              ),
                              
                              const SizedBox(height: 20),

                              // UPCOMING SESSION (MOVED TO TOP)
                              _buildUpcomingSession(),

                              const SizedBox(height: 48),

                              // THE LOG DATA FEATURE (REPLACES COMPASS)
                              Transform.translate(
                                offset: const Offset(0, -30),
                                child: const PremiumLogDataCard(),
                              ),

                              const SizedBox(height: 12),

                              // SIGNATURE FEATURE: HEALING JOURNEY
                              const HealingJourneyStrip(),

                              const SizedBox(height: 32),

                              // Transition 1: Current State
                              _buildTransitionLabel('LET\'S CHECK YOUR CURRENT STATE'),

                              const SizedBox(height: 8),

                              // Transition Insight Card (AI Intelligence 2.0)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: wellnessData == null
                                    ? _buildEmptyAssessmentCTA()
                                    : PremiumInsightCard(data: wellnessData),
                              ),
                            ],
                          );
                        },
                      ),
                
                const SizedBox(height: 32),

                // Upcoming Session (Anchored on the "Path") - REMOVED FROM HERE
                

                const SizedBox(height: 12),
                
                // Transition 3: Body Needs
                _buildTransitionLabel('YOUR BODY NEEDS ATTENTION HERE'),

                const SizedBox(height: 8),

                // Body Focus Area (Integrated better)
                StreamBuilder<WellnessData?>(
                  stream: _wellnessService.getLatestWellnessData(),
                  builder: (context, snapshot) {
                    final area = snapshot.data?.tensionArea ?? '';
                    return BodyFocusPreview(tensionArea: area);
                  },
                ),

                const SizedBox(height: 32),

              // Transition 4: Therapies
              _buildTransitionLabel('BASED ON YOUR CURRENT CONDITION'),

              const SizedBox(height: 8),

              // Recommended Therapies (Dynamic)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended Therapies',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B4236),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        MainNavigation.setIndex(context, 1);
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              _buildRecommendedTherapies(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Essential Wellness',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B4236),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        MainNavigation.setIndex(context, 2);
                      },
                      child: const Text(
                        'Shop More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildProductCard(
                        'assets/images/product_oil.png',
                        'Lavender Calm Oil',
                        '₹450',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProductCard(
                        'assets/images/product_wellness.png',
                        'Reflective Journal',
                        '₹300',
                      ),
                    ),
                    ],
                  ),
                ),
                const SizedBox(height: 60), // Bottom padding for navbar
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: const Color(0xFF2B4236).withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildEmptyAssessmentCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B4236).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AssessmentScreen()),
          );
        },
        icon: const Icon(Icons.assignment, color: Colors.white),
        label: const Text('Log Daily Assessment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B4236),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSession() {
    if (_user == null) return const SizedBox();

    return StreamBuilder<List<Booking>>(
      stream: _bookingService.getUpcomingBookings(_user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2B4236)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3EC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E8D8)),
            ),
            child: const Center(
              child: Text(
                'No sessions booked yet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B8E67),
                  ),
              ),
            ),
          );
        }

        final booking = snapshot.data!.first;
        return PremiumUpcomingSession(booking: booking);
      },
    );
  }

  Widget _buildRecommendedTherapies() {
    return StreamBuilder<List<Therapy>>(
      stream: _therapyService.getTherapies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2B4236)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No therapies found.');
        }

        final therapies = snapshot.data!.take(3).toList();

        return SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: therapies.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final therapy = therapies[index];
              return _buildTherapyCard(
                therapy
                    .imageUrl, // Assuming imageUrl exists, or use default local
                therapy.name,
                therapy.description,
                4.8,
                120,
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildQuickAction(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE4E8D8),
              border: Border.all(color: const Color(0xFF2B4236).withValues(alpha: 0.1), width: 1.5),
            ),
            child: Icon(icon, size: 26, color: const Color(0xFF2B4236)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B4236),
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
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: imagePath.startsWith('http')
                  ? Image.network(imagePath, fit: BoxFit.cover)
                  : Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '$rating',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildProductCard(String imagePath, String name, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E8D8)),
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
              errorBuilder: (_, __, ___) =>
                  Container(height: 130, color: Colors.grey[200]),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B4236),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2B4236),
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
