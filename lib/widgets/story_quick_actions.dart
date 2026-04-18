import 'package:flutter/material.dart';

class StoryQuickActions extends StatelessWidget {
  final VoidCallback onLogAssessment;
  final VoidCallback onBookTherapy;

  const StoryQuickActions({
    super.key,
    required this.onLogAssessment,
    required this.onBookTherapy,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'AI Coach',
        'subtitle': 'Ask anything',
        'icon': Icons.auto_awesome,
        'gradient': const [Color(0xFF6B7B3A), Color(0xFF4A5528)],
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI Coach coming soon!')),
          );
        },
      },
      {
        'title': 'Log Data',
        'subtitle': 'Assessment',
        'icon': Icons.assignment,
        'gradient': const [Color(0xFFE28C41), Color(0xFFB86623)],
        'onTap': onLogAssessment,
      },
      {
        'title': 'Therapy',
        'subtitle': 'Book session',
        'icon': Icons.spa,
        'gradient': const [Color(0xFF41A5E2), Color(0xFF2376B8)],
        'onTap': onBookTherapy,
      },
      {
        'title': 'Store',
        'subtitle': 'Shop items',
        'icon': Icons.shopping_bag,
        'gradient': const [Color(0xFFE2416E), Color(0xFFB8234D)],
        'onTap': () {},
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (context, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final action = actions[index];
              return GestureDetector(
                onTap: action['onTap'],
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: action['gradient'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (action['gradient'][0] as Color).withAlpha(77),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          action['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        action['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        action['subtitle'],
                        style: TextStyle(
                          color: Colors.white.withAlpha(204),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
