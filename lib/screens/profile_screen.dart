import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruh_care/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _authService.currentUser;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Profile header
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF1F3EC),
                  border: Border.all(color: const Color(0xFF6B7B3A), width: 2.5),
                ),
                child: const Icon(Icons.person, size: 42, color: Color(0xFF6B7B3A)),
              ),
              const SizedBox(height: 14),
              Text(
                _user?.displayName ?? 'Valued User',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2D3436)),
              ),
              const SizedBox(height: 4),
              Text(
                _user?.email ?? 'No email provided',
                style: const TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
              ),

              const SizedBox(height: 30),

              _buildSection('Account', [
                _buildMenuItem(Icons.person_outline, 'Edit Profile'),
                _buildMenuItem(Icons.lock_outline, 'Change Password'),
                _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
              ]),

              const SizedBox(height: 16),

              _buildSection('Activity', [
                _buildMenuItem(Icons.calendar_today_outlined, 'My Appointments'),
                _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders'),
                _buildMenuItem(Icons.school_outlined, 'My Courses'),
              ]),

              const SizedBox(height: 16),

              _buildSection('Support', [
                _buildMenuItem(Icons.help_outline, 'Help & FAQ'),
                _buildMenuItem(Icons.info_outline, 'About Ruh-Care'),
              ]),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _handleSignOut,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Sign Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFCC4444),
                    side: const BorderSide(color: Color(0xFFEECCCC)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
            color: Color(0xFF8A8A8A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F0EE)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  static Widget _buildMenuItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, size: 22, color: const Color(0xFF6B7B3A)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2D3436)),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCCCCCC)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: () {},
    );
  }
}
