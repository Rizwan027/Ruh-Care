import 'package:cloud_firestore/cloud_firestore.dart';

class WellnessData {
  final int score;
  final double stressLevel;
  final double painLevel;
  final String tensionArea;
  final String insightText;
  final String suggestion;
  final String lastSession;
  final String? notes;
  final DateTime timestamp;

  WellnessData({
    required this.score,
    required this.stressLevel,
    required this.painLevel,
    required this.tensionArea,
    required this.insightText,
    required this.suggestion,
    required this.lastSession,
    this.notes,
    required this.timestamp,
  });

  factory WellnessData.fromMap(Map<String, dynamic> map) {
    return WellnessData(
      score: map['score']?.toInt() ?? 0,
      stressLevel: (map['stressLevel'] ?? 0.0).toDouble(),
      painLevel: (map['painLevel'] ?? 0.0).toDouble(),
      tensionArea: map['tensionArea'] ?? '',
      insightText: map['insightText'] ?? '',
      suggestion: map['suggestion'] ?? '',
      lastSession: map['lastSession'] ?? '',
      notes: map['notes'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'stressLevel': stressLevel,
      'painLevel': painLevel,
      'tensionArea': tensionArea,
      'insightText': insightText,
      'suggestion': suggestion,
      'lastSession': lastSession,
      'notes': notes,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
