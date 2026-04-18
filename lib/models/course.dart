class Course {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final String imageUrl;
  final int duration; // in weeks
  final double price;
  final List<String> modules;
  final List<String> includes;
  final bool isBeginner;

  const Course({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    this.imageUrl = '',
    required this.duration,
    required this.price,
    this.modules = const [],
    this.includes = const [],
    this.isBeginner = true,
  });

  factory Course.fromFirestore(Map<String, dynamic> data, String docId) {
    dynamic durationValue = data['duration'];
    int duration;
    if (durationValue is int) {
      duration = durationValue;
    } else if (durationValue is String) {
      duration = int.tryParse(durationValue.split(' ').first) ?? 0;
    } else {
      duration = 0;
    }

    return Course(
      id: docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imagePath: data['imagePath'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      duration: duration,
      price: (data['price'] ?? 0).toDouble(),
      modules: List<String>.from(data['modules'] ?? []),
      includes: List<String>.from(data['includes'] ?? []),
      isBeginner: data['isBeginner'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'duration': duration,
      'price': price,
      'modules': modules,
      'includes': includes,
      'isBeginner': isBeginner,
    };
  }
}
