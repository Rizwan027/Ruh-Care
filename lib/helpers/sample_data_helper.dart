import 'package:cloud_firestore/cloud_firestore.dart';

class SampleDataHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print('✅ Sample therapies added successfully!');
    } catch (e) {
      print('❌ Error adding sample therapies: $e');
    }
  }
}
