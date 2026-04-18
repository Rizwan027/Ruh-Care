import 'package:flutter/material.dart';
import 'package:ruh_care/models/course.dart';
import 'package:ruh_care/screens/offline_enrollment_screen.dart';
import 'package:ruh_care/services/course_service.dart';
import 'package:ruh_care/helpers/sample_data_helper.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CourseService _courseService = CourseService();
  final SampleDataHelper _sampleDataHelper = SampleDataHelper();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _seedSampleCoursesIfNeeded();
  }

  Future<void> _seedSampleCoursesIfNeeded() async {
    await _sampleDataHelper.addSampleCoursesIfEmpty();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF2B4236)),
              )
            : StreamBuilder<List<Course>>(
                stream: _courseService.getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2B4236),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              _seedSampleCoursesIfNeeded();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No courses available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final courses = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Offline Courses',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2B4236),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Professional offline training in Hijama',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B8E67),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...courses.map(
                          (course) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildCourseCard(
                              context: context,
                              course: course,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  static Widget _buildCourseCard({
    required BuildContext context,
    required Course course,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E8D8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              course.imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: Colors.grey[200],
                child: const Icon(Icons.school, size: 64, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E8D8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course.isBeginner ? 'Beginner' : 'Advanced',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: course.isBeginner
                              ? const Color(0xFF2B4236)
                              : const Color(0xFF6B8E67),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B8E67),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF2B4236),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.duration} weeks',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.currency_rupee,
                        size: 14,
                        color: Color(0xFF2B4236),
                      ),
                      Text(
                        '${course.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (course.modules.isNotEmpty) ...[
                  Text(
                    '${course.modules.length} Modules',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B8E67),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OfflineEnrollmentScreen(courseName: course.name),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4236),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Enroll Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
