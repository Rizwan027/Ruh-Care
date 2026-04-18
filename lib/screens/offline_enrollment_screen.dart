import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ruh_care/models/offline_course_request.dart';
import 'package:ruh_care/services/offline_course_service.dart';
import 'package:ruh_care/models/app_notification.dart';
import 'package:ruh_care/services/notification_service.dart';

class OfflineEnrollmentScreen extends StatefulWidget {
  final String courseName;

  const OfflineEnrollmentScreen({super.key, required this.courseName});

  @override
  State<OfflineEnrollmentScreen> createState() => _OfflineEnrollmentScreenState();
}

class _OfflineEnrollmentScreenState extends State<OfflineEnrollmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _offlineCourseService = OfflineCourseService();
  final _notificationService = NotificationService();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _messageController;

  DateTime? _selectedDate;
  String? _selectedTime;

  final List<String> _timeSlots = [
    '09:00 AM', '10:30 AM', '12:00 PM', '02:00 PM', '04:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: ''); // Phone might not be in basic auth, leave editable or fetch if available
    _emailController = TextEditingController(text: user?.email ?? '');
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6B7B3A)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a preferred date'), backgroundColor: Colors.red));
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a preferred time slot'), backgroundColor: Colors.red));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final request = OfflineCourseRequest(
        id: '',
        userId: user.uid,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        courseName: widget.courseName,
        preferredDate: DateFormat('MMM dd, yyyy').format(_selectedDate!),
        preferredTime: _selectedTime!,
        message: _messageController.text.trim(),
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      await _offlineCourseService.submitRequest(request);

      final notif = AppNotification(
        id: '',
        userId: user.uid,
        message: 'Your offline enrollment request for ${widget.courseName} has been received!',
        createdAt: DateTime.now(),
      );
      await _notificationService.createNotification(notif);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Request Submitted 🎉', style: TextStyle(color: Color(0xFF6B7B3A))),
            content: const Text('Your offline class request has been submitted successfully. Our team will contact you shortly to confirm your slot.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // dialog
                  Navigator.of(context).pop(); // enrollment screen
                },
                child: const Text('OK', style: TextStyle(color: Color(0xFF6B7B3A))),
              )
            ],
          )
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit request'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Offline Enrollment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3EC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4E8D8)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: Color(0xFF6B7B3A)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.courseName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3436)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _buildLabel('Full Name'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Enter your full name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              _buildLabel('Phone Number'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Enter your phone number'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              _buildLabel('Email Address'),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: _inputDecoration('Email').copyWith(fillColor: Colors.grey[100], filled: true),
              ),
              const SizedBox(height: 24),

              const Text('Preferred Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Color(0xFF6B7B3A)),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDate == null ? 'Select Date' : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                              style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildLabel('Preferred Time Slot'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Select a time', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    value: _selectedTime,
                    items: _timeSlots.map((ts) => DropdownMenuItem(value: ts, child: Text(ts))).toList(),
                    onChanged: (val) => setState(() => _selectedTime = val),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel('Additional Message (Optional)'),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: _inputDecoration('Any specific requirements or questions?'),
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B7B3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2D3436))),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6B7B3A), width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
