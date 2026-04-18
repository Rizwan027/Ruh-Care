import 'package:flutter/material.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      appBar: AppBar(
        title: const Text('Help & FAQs', style: TextStyle(color: Color(0xFF2B4236), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF1F3EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B4236)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildFaqItem(
               'How do I book a therapy session?',
               'You can book a therapy session by navigating to the Therapies page, selecting a therapy, and choosing an available date and time. Then, click "Confirm Booking".'
             ),
             _buildFaqItem(
               'How can I cancel my appointment?',
               'To cancel an appointment, go to the Profile tab, tap on "My Appointments", select the upcoming session, and click the cancel button. Alternatively, you can contact our support team.'
             ),
             _buildFaqItem(
               'How do I order products?',
               'To buy products, navigate to the Store tab, select the product you are interested in, add it to your cart, and proceed to checkout.'
             ),
             _buildFaqItem(
               'How do I enroll in courses?',
               'Go to the Courses tab, select the course you wish to learn, and click on "Enroll Now". Once enrolled, you can access it anytime from Profile > My Courses.'
             ),
             _buildFaqItem(
               'How do I reset my password?',
               'You can change your password by going to Profile > Change Password. You can either enter your old password to create a new one, or request a reset link to be sent to your email.'
             ),
            
             const SizedBox(height: 40),

             SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contacting Support...')));
                  },
                  icon: const Icon(Icons.support_agent, size: 20),
                  label: const Text('Contact Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                   style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2B4236),
                    side: const BorderSide(color: Color(0xFF2B4236)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E8D8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B4236).withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2B4236)),
        ),
        iconColor: const Color(0xFF2B4236),
        collapsedIconColor: const Color(0xFF6B8E67),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
           Text(answer, style: const TextStyle(color: Color(0xFF2B4236), height: 1.5)),
        ],
      ),
    );
  }
}
