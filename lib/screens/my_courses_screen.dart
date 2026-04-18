import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruh_care/models/enrolled_course.dart';
import 'package:ruh_care/models/offline_course_request.dart';
import 'package:ruh_care/services/course_service.dart';
import 'package:ruh_care/services/offline_course_service.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final courseService = CourseService();
    final offlineCourseService = OfflineCourseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Courses', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: user == null
        ? const Center(child: Text('Please login to view courses'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Online Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
                const SizedBox(height: 16),
                StreamBuilder<List<EnrolledCourse>>(
                  stream: courseService.getEnrolledCourses(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF6B7B3A)));
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(color: const Color(0xFFF8F8F6), borderRadius: BorderRadius.circular(16)),
                        child: const Center(child: Text('No online courses enrolled', style: TextStyle(color: Colors.grey, fontSize: 14))),
                      );
                    }
                    final courses = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEEEEEE)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(color: const Color(0xFF6B7B3A).withAlpha(30), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.play_circle_fill, color: Color(0xFF6B7B3A), size: 26),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course.courseName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: course.progress,
                                            backgroundColor: Colors.grey[300],
                                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B7B3A)),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text('${(course.progress * 100).toInt()}%', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                const Text('Offline Course Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
                const SizedBox(height: 16),
                
                StreamBuilder<List<OfflineCourseRequest>>(
                  stream: offlineCourseService.getUserRequests(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF6B7B3A)));
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(color: const Color(0xFFF8F8F6), borderRadius: BorderRadius.circular(16)),
                        child: const Center(child: Text('No offline course requests', style: TextStyle(color: Colors.grey, fontSize: 14))),
                      );
                    }
                    final requests = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        final isPending = req.status == 'Pending';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEEEEEE)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(req.courseName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isPending ? Colors.orange.withAlpha(30) : Colors.green.withAlpha(30),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      req.status, 
                                      style: TextStyle(fontSize: 12, color: isPending ? Colors.orange[800] : Colors.green[800], fontWeight: FontWeight.bold)
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text('${req.preferredDate} at ${req.preferredTime}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
