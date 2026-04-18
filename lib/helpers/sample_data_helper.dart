import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SampleDataHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSampleProductsIfEmpty() async {
    try {
      final existing = await _firestore.collection('products').limit(1).get();
      if (existing.docs.isNotEmpty) {
        await updateProductImages();
        return;
      }
      await addSampleProducts();
    } catch (e) {
      debugPrint('Error seeding sample products: $e');
    }
  }

  Future<void> updateProductImages() async {
    final imageMap = {
      'Talbina with Dry Fruits': 'assets/images/product_wellness.png',
      'Olive Oil': 'assets/images/product_oil.png',
      'Sirka (Anar & Olive)': 'assets/images/product_oil.png',
      'Ajwah Khajoor Powder': 'assets/images/product_wellness.png',
      'Badam Oil (Spain)': 'assets/images/product_oil.png',
      'Shilajit': 'assets/images/product_wellness.png',
      'Zafran': 'assets/images/product_wellness.png',
    };

    try {
      final products = await _firestore.collection('products').get();
      for (var doc in products.docs) {
        final name = doc.data()['name'] as String;
        if (imageMap.containsKey(name)) {
          await doc.reference.update({'imagePath': imageMap[name]});
        }
      }
      debugPrint('Product images updated!');
    } catch (e) {
      debugPrint('Error updating product images: $e');
    }
  }

  Future<void> addSampleProducts() async {
    final products = [
      {
        'name': 'Talbina with Dry Fruits',
        'size': '250g',
        'price': 300,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'A soothing, nutritious porridge made from barley and natural dry fruits. Excellent for digestion and a healthy heart.',
        'reviews': [
          {
            'authorName': 'Sarah K.',
            'rating': 5.0,
            'comment':
                'Absolutely love this! It has completely changed my daily morning routine. Tastes incredibly natural.',
            'date': DateTime.now().subtract(const Duration(days: 2)),
            'isVerifiedPurchase': true,
            'reviewImages': ['assets/images/product_wellness.png'],
          },
          {
            'authorName': 'Ahmed M.',
            'rating': 4.0,
            'comment': 'Great quality and fast delivery. Very satisfying.',
            'date': DateTime.now().subtract(const Duration(days: 10)),
            'isVerifiedPurchase': true,
          },
        ],
      },
      {
        'name': 'Olive Oil',
        'size': '500ml',
        'price': 900,
        'imagePath': 'assets/images/product_oil.png',
        'description':
            'Premium extra virgin olive oil cold-pressed perfectly to retain its natural antioxidants and flavors.',
        'reviews': [
          {
            'authorName': 'Fatima Z.',
            'rating': 5.0,
            'comment':
                'The scent and purity is top notch. I use it both for cooking and skincare.',
            'date': DateTime.now().subtract(const Duration(days: 14)),
            'isVerifiedPurchase': true,
          },
        ],
      },
      {
        'name': 'Olive Oil',
        'size': '200ml',
        'price': 330,
        'imagePath': 'assets/images/product_oil.png',
        'description':
            'Premium extra virgin olive oil cold-pressed perfectly to retain its natural antioxidants and flavors. Compact size.',
        'reviews': [],
      },
      {
        'name': 'Sirka (Anar & Olive)',
        'size': '500ml',
        'price': 300,
        'imagePath': 'assets/images/product_oil.png',
        'description':
            'Natural vinegar blend of pomegranate and olive. Great for metabolism and culinary uses.',
        'reviews': [
          {
            'authorName': 'Tariq A.',
            'rating': 4.5,
            'comment': 'Very sharp and authentic taste. High quality sirka.',
            'date': DateTime.now().subtract(const Duration(days: 4)),
            'isVerifiedPurchase': false,
          },
        ],
      },
      {
        'name': 'Ajwah Khajoor Powder',
        'size': '100g',
        'price': 600,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'Authentic Ajwah date seed powder, highly regarded for cardiovascular health and packed with essential nutrients.',
        'reviews': [],
      },
      {
        'name': 'Badam Oil (Spain)',
        'size': '100ml',
        'price': 370,
        'imagePath': 'assets/images/product_oil.png',
        'description':
            'Pure Spanish almond oil. Rich in Vitamin E, perfect for skin, hair care, and wellness remedies.',
        'reviews': [],
      },
      {
        'name': 'Shilajit',
        'size': '10g',
        'price': 500,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'Pure Himalayan Shilajit resin boosting energy levels naturally and supporting immune health.',
        'reviews': [
          {
            'authorName': 'Imran N.',
            'rating': 5.0,
            'comment': 'Incredible energy boost after just a week of use.',
            'date': DateTime.now().subtract(const Duration(days: 20)),
            'isVerifiedPurchase': true,
          },
        ],
      },
      {
        'name': 'Zafran',
        'size': '1g',
        'price': 450,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'Top-tier saffron threads to infuse your lifestyle and recipes with rich aroma, flavor, and potent health benefits.',
        'reviews': [],
      },
      {
        'name': 'Kalonji Oil',
        'size': '100ml',
        'price': 250,
        'imagePath': 'assets/images/product_oil.png',
        'description':
            'Pure black seed oil extracted from nigella sativa seeds. Known for immune support and respiratory health.',
        'reviews': [],
      },
      {
        'name': 'Rose Water',
        'size': '200ml',
        'price': 180,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'Natural rose water for skin toning, hair care, and natural refreshment. Steam distilled from fresh roses.',
        'reviews': [],
      },
      {
        'name': 'Hajmola Tablets',
        'size': '10 strips',
        'price': 120,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'Traditional digestive tablets with a blend of natural ingredients. Helps relieve indigestion and bloating.',
        'reviews': [],
      },
      {
        'name': 'Coconut Oil',
        'size': '250ml',
        'price': 280,
        'imagePath': 'assets/images/product_oil.png',
        'description':
            'Cold-pressed virgin coconut oil. Perfect for cooking, skin care, and hair nourishment.',
        'reviews': [],
      },
      {
        'name': 'Henna Powder',
        'size': '200g',
        'price': 150,
        'imagePath': 'assets/images/product_wellness.png',
        'description':
            'Natural henna powder for hair coloring and cooling treatments. Free from chemicals and additives.',
        'reviews': [],
      },
    ];

    try {
      for (var product in products) {
        await _firestore.collection('products').add(product);
      }
      debugPrint('Sample products added successfully!');
    } catch (e) {
      debugPrint('Error adding sample products: $e');
    }
  }

  Future<void> addSampleTherapiesIfEmpty() async {
    try {
      final existing = await _firestore.collection('therapies').limit(1).get();
      if (existing.docs.isNotEmpty) {
        return;
      }
      await addSampleTherapies();
    } catch (e) {
      debugPrint('❌ Error seeding sample therapies: $e');
    }
  }

  Future<void> addSampleTherapies() async {
    final therapies = [
      {
        'name': 'Dry Cupping',
        'description':
            'Suction therapy to improve blood flow and reduce muscle tension...',
        'duration': 30,
        'price': 45,
        'category': 'Cupping',
        'tag': 'Certified',
        'imageUrl': '',
        'benefits': [
          'Improves blood circulation',
          'Reduces muscle tension',
          'Relieves pain and inflammation',
          'Promotes relaxation',
        ],
        'precautions': [
          'Not recommended for pregnant women',
          'Avoid if you have skin conditions',
          'Not suitable for hemophiliacs',
        ],
      },
      {
        'name': 'Wet Cupping (Hijama)',
        'description':
            'Traditional medicinal practice involving suction and medicinal...',
        'duration': 45,
        'price': 65,
        'category': 'Cupping',
        'tag': 'Sterile',
        'imageUrl': '',
        'benefits': [
          'Detoxifies the body',
          'Boosts immune system',
          'Improves blood quality',
          'Relieves chronic pain',
          'Enhances overall wellness',
        ],
        'precautions': [
          'Must be done by certified practitioner',
          'Not for people with anemia',
          'Avoid during menstruation',
          'Not suitable for children under 12',
        ],
      },
      {
        'name': 'Fire Cupping',
        'description':
            'Using heat to create suction in glass jars to stimulate deeper...',
        'duration': 40,
        'price': 55,
        'category': 'Cupping',
        'tag': 'Warming',
        'imageUrl': '',
        'benefits': [
          'Deep tissue stimulation',
          'Improves energy flow',
          'Releases deep muscle knots',
          'Warms and relaxes the body',
        ],
        'precautions': [
          'Careful with sensitive skin',
          'Not for those with fear of fire',
          'May leave temporary marks',
          'Avoid if you have fever',
        ],
      },
      {
        'name': 'Leech Therapy',
        'description':
            'Specialized treatment using medicinal leeches to improve...',
        'duration': 60,
        'price': 85,
        'category': 'Energy',
        'tag': 'Bio-Natural',
        'imageUrl': '',
        'benefits': [
          'Improves blood circulation',
          'Natural blood purification',
          'Anti-inflammatory properties',
          'Treats varicose veins',
          'Helps with arthritis',
        ],
        'precautions': [
          'Only medicinal leeches used',
          'Not for immunocompromised patients',
          'Avoid if taking blood thinners',
          'Risk of allergic reaction',
        ],
      },
      {
        'name': 'Acupuncture',
        'description':
            'Ancient technique using thin needles to balance the body\'s...',
        'duration': 50,
        'price': 70,
        'category': 'Energy',
        'tag': 'Energy',
        'imageUrl': '',
        'benefits': [
          'Balances body energy',
          'Relieves stress and anxiety',
          'Treats chronic pain',
          'Improves sleep quality',
          'Enhances mental clarity',
        ],
        'precautions': [
          'Use of sterile needles only',
          'Not for people with bleeding disorders',
          'Inform practitioner of pacemakers',
          'May cause mild bruising',
        ],
      },
      {
        'name': 'Kasa Thali Therapy',
        'description':
            'Ayurvedic foot massage using a special bronze bowl to detoxify...',
        'duration': 30,
        'price': 40,
        'category': 'Massage',
        'tag': 'Reflexology',
        'imageUrl': '',
        'benefits': [
          'Detoxifies through feet',
          'Improves circulation',
          'Reduces stress',
          'Balances body energy',
          'Promotes better sleep',
        ],
        'precautions': [
          'Not for open wounds on feet',
          'Avoid if pregnant',
          'Not suitable for diabetic neuropathy',
          'May cause temporary discomfort',
        ],
      },
    ];

    try {
      for (var therapy in therapies) {
        await _firestore.collection('therapies').add(therapy);
      }
      debugPrint('✅ Sample therapies added successfully!');
    } catch (e) {
      debugPrint('❌ Error adding sample therapies: $e');
    }
  }

  Future<void> addSampleCoursesIfEmpty() async {
    try {
      final existing = await _firestore.collection('courses').limit(1).get();
      if (existing.docs.isNotEmpty) {
        return;
      }
      await addSampleCourses();
    } catch (e) {
      debugPrint('Error seeding sample courses: $e');
    }
  }

  Future<void> addSampleCourses() async {
    final courses = [
      {
        'name': 'Beginners Hijama Course',
        'description':
            'Introductory course covering basics of Hijama (cupping therapy), safety, and techniques.',
        'imagePath': 'assets/images/course_basic_hijama.jpg',
        'duration': 4,
        'price': 4999,
        'isBeginner': true,
        'modules': [
          'Introduction to Hijama',
          'Understanding Cupping Points',
          'Safety and Hygiene',
          'Basic Cupping Techniques',
          'Aftercare Instructions',
        ],
        'includes': [
          'Video Lessons',
          'PDF Materials',
          'Certificate of Completion',
          'WhatsApp Support',
        ],
      },
      {
        'name': 'Advance Hijama Course',
        'description':
            'Advanced techniques, practical applications, and professional-level training in Hijama.',
        'imagePath': 'assets/images/course_advanced_hijama.jpg',
        'duration': 8,
        'price': 9999,
        'isBeginner': false,
        'modules': [
          'Deep Dive into Hijama Points',
          'Wet Cupping Techniques',
          'Fire Cupping Methods',
          'Treatment Protocols for Various Conditions',
          'Business Setup for Hijama Practice',
          'Advanced Case Studies',
          'Live Demonstrations',
          'Practical Assessment',
        ],
        'includes': [
          'Video Lessons',
          'Live Sessions',
          'PDF Materials',
          'Certificate of Completion',
          '1-on-1 Mentoring',
          'Business Consultation',
        ],
      },
    ];

    try {
      for (var course in courses) {
        await _firestore.collection('courses').add(course);
      }
      debugPrint('Sample courses added successfully!');
    } catch (e) {
      debugPrint('Error adding sample courses: $e');
    }
  }
}
