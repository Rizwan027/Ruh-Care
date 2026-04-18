import 'package:flutter/material.dart';
import 'package:ruh_care/helpers/sample_data_helper.dart';
import 'package:ruh_care/models/therapy.dart';
import 'package:ruh_care/services/therapy_service.dart';
import 'package:ruh_care/screens/therapy_detail_screen.dart';

class TherapiesScreen extends StatefulWidget {
  const TherapiesScreen({super.key});

  @override
  State<TherapiesScreen> createState() => _TherapiesScreenState();
}

class _TherapiesScreenState extends State<TherapiesScreen> {
  final TherapyService _therapyService = TherapyService();
  final SampleDataHelper _sampleDataHelper = SampleDataHelper();
  String _selectedCategory = 'All Therapies';
  final List<Therapy> _fallbackTherapies = [
    Therapy(
      id: 'local-1',
      name: 'Acupuncture',
      description: 'Ancient technique using thin needles to balance the body.',
      benefits: const [],
      precautions: const [],
      duration: 50,
      price: 700,
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
      category: 'Energy',
      tag: 'Energy',
    ),
    Therapy(
      id: 'local-2',
      name: 'Dry Cupping',
      description:
          'Suction therapy to improve blood flow and reduce muscle tension.',
      benefits: const [],
      precautions: const [],
      duration: 30,
      price: 450,
      imageUrl:
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400',
      category: 'Cupping',
      tag: 'Certified',
    ),
    Therapy(
      id: 'local-3',
      name: 'Wet Cupping (Hijama)',
      description:
          'Traditional medicinal practice involving suction and medicinal techniques.',
      benefits: const [],
      precautions: const [],
      duration: 45,
      price: 650,
      imageUrl:
          'https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=400',
      category: 'Cupping',
      tag: 'Sterile',
    ),
  ];

  final List<String> _categories = [
    'All Therapies',
    'Cupping',
    'Energy',
    'Massage',
  ];

  @override
  void initState() {
    super.initState();
    _seedSampleTherapiesIfNeeded();
  }

  Future<void> _seedSampleTherapiesIfNeeded() async {
    await _sampleDataHelper.addSampleTherapiesIfEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F3EC),
        elevation: 0,
        toolbarHeight: 0, // hide the AppBar completely
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header matching Wellness Store style
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Therapies',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2B4236),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Find your healing practice',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF2B4236).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, size: 26, color: Color(0xFF2B4236)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category Filter Tabs
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2B4236)
                            : const Color(0xFFE4E8D8),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF2B4236),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Therapies List
            Expanded(
              child: StreamBuilder<List<Therapy>>(
                stream: _selectedCategory == 'All Therapies'
                    ? _therapyService.getTherapies()
                    : _therapyService.getTherapiesByCategory(_selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    final errorText = snapshot.error.toString();
                    if (errorText.contains('permission-denied')) {
                      final filteredTherapies =
                          _selectedCategory == 'All Therapies'
                          ? _fallbackTherapies
                          : _fallbackTherapies
                                .where((t) => t.category == _selectedCategory)
                                .toList();

                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4E5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE4E8D8),
                              ),
                            ),
                            child: const Text(
                              'Using offline sample data because Firestore permissions are blocked.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A5A00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(child: _buildTherapyList(filteredTherapies)),
                        ],
                      );
                    }
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No therapies available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final therapies = snapshot.data!;
                  return _buildTherapyList(therapies);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapyList(List<Therapy> therapies) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: therapies.length,
      itemBuilder: (context, index) {
        return _buildTherapyCard(therapies[index]);
      },
    );
  }

  Widget _buildTherapyCard(Therapy therapy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Therapy Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: therapy.imageUrl.isNotEmpty
                      ? Image.network(
                          therapy.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                      : _buildPlaceholderImage(),
                ),
                const SizedBox(width: 16),

                // Therapy Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        therapy.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        therapy.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B8E67),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${therapy.duration} Mins',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B8E67),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            therapy.tag,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B8E67),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '₹${therapy.price.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B4236),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TherapyDetailScreen(therapy: therapy),
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
                  'Book Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF2B4236).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.spa, color: Color(0xFF2B4236), size: 40),
    );
  }
}
