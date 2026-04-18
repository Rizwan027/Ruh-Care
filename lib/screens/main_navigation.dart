import 'package:flutter/material.dart';
import 'package:ruh_care/helpers/responsive_helper.dart';
import 'package:ruh_care/screens/home_screen.dart';
import 'package:ruh_care/screens/therapies_screen.dart';
import 'package:ruh_care/screens/store_screen.dart';
import 'package:ruh_care/screens/courses_screen.dart';
import 'package:ruh_care/screens/profile_screen.dart';
import 'package:ruh_care/services/notification_service.dart';
import 'package:ruh_care/widgets/notification_popover.dart';
import 'package:ruh_care/screens/notifications_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  static void setIndex(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationState>();
    state?.setIndex(index);
  }

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  StreamSubscription? _notificationSubscription;
  DateTime _sessionStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _startNotificationListener();
  }

  void _startNotificationListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _notificationSubscription = NotificationService()
          .getUserNotifications(user.uid)
          .listen((notifications) {
            if (notifications.isNotEmpty) {
              final latest = notifications.first;
              // Only show if notification is newer than when we started this session
              if (latest.createdAt.isAfter(_sessionStartTime)) {
                // Update session start time to prevent double-showing
                _sessionStartTime = latest.createdAt;

                // Show the popover
                if (mounted) {
                  NotificationPopover.show(context, latest.message, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  });
                }
              }
            }
          });
    }
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    TherapiesScreen(),
    StoreScreen(),
    CoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3EC),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildNavItem(Icons.home_rounded, 'Home', 0)),
                Expanded(child: _buildNavItem(Icons.spa_rounded, 'Therapies', 1)),
                Expanded(child: _buildNavItem(Icons.storefront_rounded, 'Store', 2)),
                Expanded(child: _buildNavItem(Icons.menu_book_rounded, 'Courses', 3)),
                Expanded(child: _buildNavItem(Icons.person_rounded, 'Profile', 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final isSmall = Responsive.isSmallScreen(context);
    
    return GestureDetector(
      onTap: () => setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 4 : 12, 
          vertical: 8
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2B4236).withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSmall ? 22 : 24,
              color: isSelected
                  ? const Color(0xFF2B4236)
                  : const Color(0xFF9E9E9E),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: isSmall ? 10 : 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF2B4236)
                      : const Color(0xFF9E9E9E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
