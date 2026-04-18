import 'package:flutter/material.dart';
import 'package:ruh_care/models/wellness_data.dart';
import 'package:ruh_care/services/wellness_service.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final WellnessService _wellnessService = WellnessService();
  
  double _stressLevel = 5;
  double _painLevel = 5;
  String _tensionArea = 'Neck';
  
  final List<String> _areas = ['Neck', 'Shoulders', 'Lower Back', 'Upper Back', 'Legs', 'Full Body', 'Other'];
  final TextEditingController _customAreaController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _customAreaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitAssessment() async {
    setState(() {
      _isSubmitting = true;
    });

    // Mock calculation
    int score = 100 - ((_stressLevel + _painLevel) * 5).toInt();
    if (score < 10) score = 10;

    // Mock insight generation based on data
    String insightText = "You're doing better than yesterday";
    String suggestion = "Consider a 15-min guided meditation.";
    
    if (_stressLevel > 7) {
      insightText = "Your stress levels are elevated today.";
      suggestion = "A deep breathing session and cupping therapy on the $_tensionArea is highly recommended.";
    } else if (_painLevel > 7) {
      insightText = "Focus on pain relief today.";
      suggestion = "Cupping therapy on your $_tensionArea can help reduce muscle tension by 20%.";
    } else if (_stressLevel < 4 && _painLevel < 4) {
      insightText = "Your $_tensionArea tension has reduced by 15%!";
      suggestion = "Keep up the good work! Maintain your routine.";
    }

    try {
      final actualTensionArea = (_tensionArea == 'Other' && _customAreaController.text.trim().isNotEmpty) 
          ? _customAreaController.text.trim() 
          : _tensionArea;

      final data = WellnessData(
        score: score,
        stressLevel: _stressLevel,
        painLevel: _painLevel,
        tensionArea: actualTensionArea,
        insightText: insightText,
        suggestion: suggestion,
        lastSession: 'Cupping Therapy', // Mocking last session
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        timestamp: DateTime.now(),
      );

      await _wellnessService.saveAssessment(data);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save assessment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      appBar: AppBar(
        title: const Text('Therapy Assessment', style: TextStyle(color: Color(0xFF2B4236), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF1F3EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B4236)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B4236)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Let us know your current state to personalize your wellness journey.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B8E67)),
            ),
            const SizedBox(height: 32),
            
            // Stress Level
            _buildSliderSection(
              title: 'Stress Level',
              value: _stressLevel,
              onChanged: (val) => setState(() => _stressLevel = val),
              icon: Icons.psychology,
            ),
            const SizedBox(height: 24),
            
            // Pain Level
            _buildSliderSection(
              title: 'Pain / Tension Level',
              value: _painLevel,
              onChanged: (val) => setState(() => _painLevel = val),
              icon: Icons.healing,
            ),
            const SizedBox(height: 24),
            
            // Primary Tension Area
            const Text(
              'Primary Tension Area',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B4236)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _areas.map((area) {
                final isSelected = _tensionArea == area;
                return ChoiceChip(
                  label: Text(area),
                  selected: isSelected,
                  selectedColor: const Color(0xFF2B4236),
                  backgroundColor: const Color(0xFFF8F8F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF2B4236) : const Color(0xFFE4E8D8),
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF2B4236),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _tensionArea = area);
                    }
                  },
                );
              }).toList(),
            ),
            
            if (_tensionArea == 'Other') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _customAreaController,
                decoration: InputDecoration(
                  hintText: 'Please specify the area (e.g., Knees, Wrists)',
                  hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF8F8F6),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE4E8D8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE4E8D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF2B4236)),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            const Text(
              'Additional Notes / Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B4236)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'E.g., Sharp pain on the right side when bending over...',
                hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                filled: true,
                fillColor: const Color(0xFFF8F8F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE4E8D8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE4E8D8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF2B4236)),
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitAssessment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B4236),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Assessment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection({required String title, required double value, required Function(double) onChanged, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF2B4236)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B4236)),
            ),
            const Spacer(),
            Text(
              '${value.toInt()}/10',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B4236)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          activeColor: const Color(0xFF2B4236),
          inactiveColor: const Color(0xFFE4E8D8),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
