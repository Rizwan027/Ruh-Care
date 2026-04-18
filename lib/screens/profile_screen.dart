import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruh_care/services/auth_service.dart';
import 'package:ruh_care/services/user_service.dart';
import 'package:ruh_care/screens/edit_profile_screen.dart';
import 'package:ruh_care/screens/change_password_screen.dart';
import 'package:ruh_care/screens/my_appointments_screen.dart';
import 'package:ruh_care/screens/my_orders_screen.dart';
import 'package:ruh_care/screens/my_courses_screen.dart';
import 'package:ruh_care/screens/help_faq_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _userService = UserService();
  late User? _user;
  String _displayName = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = _authService.currentUser;
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

  void _refreshUser() {
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
    });
    _loadUserName();
  }

  void _handleSignOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF1F3EC),
                  border: Border.all(
                    color: const Color(0xFF2B4236),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 42,
                   color: Color(0xFF2B4236),
                ),
              ),
              const SizedBox(height: 14),
               _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF2B4236))
                  : Text(
                      _displayName,
                       style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2B4236),
                      ),
                    ),
              const SizedBox(height: 4),
              Text(
                _user?.email ?? 'No email provided',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B8E67)),
              ),

              const SizedBox(height: 30),

              _buildSection('Account', [
                _buildMenuItem(Icons.person_outline, 'Edit Profile', () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                  _refreshUser();
                }),
                _buildMenuItem(Icons.lock_outline, 'Change Password', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordScreen(),
                    ),
                  );
                }),
              ]),

              const SizedBox(height: 16),

              _buildSection('Activity', [
                _buildMenuItem(
                  Icons.calendar_today_outlined,
                  'My Appointments',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyAppointmentsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                  );
                }),
                _buildMenuItem(Icons.school_outlined, 'My Courses', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyCoursesScreen()),
                  );
                }),
              ]),

              const SizedBox(height: 16),

              _buildSection('Support', [
                _buildMenuItem(Icons.help_outline, 'Help & FAQ', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpFaqScreen()),
                  );
                }),
                _buildMenuItem(Icons.info_outline, 'About Ruh-Care', () {}),
              ]),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _handleSignOut,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFCC4444),
                    side: const BorderSide(color: Color(0xFFEECCCC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFF6B8E67),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E8D8)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  static Widget _buildMenuItem(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, size: 22, color: const Color(0xFF2B4236)),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2B4236),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: Color(0xFF6B8E67),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: onTap,
    );
  }
}
