import 'package:flutter/material.dart';

class DailyActionPlan extends StatefulWidget {
  const DailyActionPlan({super.key});

  @override
  State<DailyActionPlan> createState() => _DailyActionPlanState();
}

class _DailyActionPlanState extends State<DailyActionPlan> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Drink 2L Water', 'completed': false, 'icon': Icons.water_drop},
    {'title': 'Morning Stretch', 'completed': true, 'icon': Icons.accessibility_new},
    {'title': '15 Min Meditation', 'completed': false, 'icon': Icons.self_improvement},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7B3A).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Routine',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B7B3A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_tasks.where((t) => t['completed'] as bool).length}/${_tasks.length}',
                  style: const TextStyle(
                    color: Color(0xFF6B7B3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_tasks.length, (index) {
            final task = _tasks[index];
            final isCompleted = task['completed'] as bool;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _tasks[index]['completed'] = !isCompleted;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFF8F8F6) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted ? Colors.transparent : const Color(0xFFE4E8D8),
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted ? const Color(0xFF6B7B3A) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted ? const Color(0xFF6B7B3A) : const Color(0xFFB0B0B0),
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      task['icon'] as IconData,
                      size: 20,
                      color: isCompleted ? const Color(0xFFB0B0B0) : const Color(0xFF6B7B3A),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isCompleted ? FontWeight.normal : FontWeight.w600,
                          color: isCompleted ? const Color(0xFFB0B0B0) : const Color(0xFF2D3436),
                          decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                        child: Text(task['title'] as String),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
