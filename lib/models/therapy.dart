class Therapy {
  final String id;
  final String name;
  final String description;
  final List<String> benefits;
  final List<String> precautions;
  final int duration; // in minutes
  final double price;
  final String imageUrl;
  final String category; // e.g., "Cupping", "Energy", "Massage"
  final String tag; // e.g., "Certified", "Sterile", "Bio-Natural"

  Therapy({
    required this.id,
    required this.name,
    required this.description,
    required this.benefits,
    required this.precautions,
    required this.duration,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.tag,
  });

  factory Therapy.fromFirestore(Map<String, dynamic> data, String docId) {
    return Therapy(
      id: docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      benefits: List<String>.from(data['benefits'] ?? []),
      precautions: List<String>.from(data['precautions'] ?? []),
      duration: data['duration'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'General',
      tag: data['tag'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'benefits': benefits,
      'precautions': precautions,
      'duration': duration,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'tag': tag,
    };
  }
}
