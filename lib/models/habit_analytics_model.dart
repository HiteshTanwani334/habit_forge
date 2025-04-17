import 'package:flutter/foundation.dart';

class HabitAnalytics {
  final Map<String, double> weeklyTrend;
  final Map<String, int> dailyCompletion;
  final Map<String, double> timeOfDayCompletion;
  final Map<String, double> categorySuccessRates;
  final List<HabitInsight> insights;
  final List<HabitRecommendation> recommendations;

  HabitAnalytics({
    required this.weeklyTrend,
    required this.dailyCompletion,
    required this.timeOfDayCompletion,
    required this.categorySuccessRates,
    required this.insights,
    required this.recommendations,
  });

  factory HabitAnalytics.fromJson(Map<String, dynamic> json) {
    return HabitAnalytics(
      weeklyTrend: Map<String, double>.from(json['weeklyTrend']),
      dailyCompletion: Map<String, int>.from(json['dailyCompletion']),
      timeOfDayCompletion: Map<String, double>.from(json['timeOfDayCompletion']),
      categorySuccessRates: Map<String, double>.from(json['categorySuccessRates']),
      insights: (json['insights'] as List)
          .map((i) => HabitInsight.fromJson(i))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map((r) => HabitRecommendation.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weeklyTrend': weeklyTrend,
      'dailyCompletion': dailyCompletion,
      'timeOfDayCompletion': timeOfDayCompletion,
      'categorySuccessRates': categorySuccessRates,
      'insights': insights.map((i) => i.toJson()).toList(),
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
    };
  }
}

class HabitInsight {
  final String title;
  final String description;
  final String type;
  final DateTime date;

  HabitInsight({
    required this.title,
    required this.description,
    required this.type,
    required this.date,
  });

  factory HabitInsight.fromJson(Map<String, dynamic> json) {
    return HabitInsight(
      title: json['title'],
      description: json['description'],
      type: json['type'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'date': date.toIso8601String(),
    };
  }
}

class HabitRecommendation {
  final String title;
  final String description;
  final String category;
  final double confidence;
  final List<String> relatedHabits;

  HabitRecommendation({
    required this.title,
    required this.description,
    required this.category,
    required this.confidence,
    required this.relatedHabits,
  });

  factory HabitRecommendation.fromJson(Map<String, dynamic> json) {
    return HabitRecommendation(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      confidence: json['confidence'],
      relatedHabits: List<String>.from(json['relatedHabits']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'confidence': confidence,
      'relatedHabits': relatedHabits,
    };
  }
}

class HabitAchievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime earnedAt;
  final int points;

  HabitAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.earnedAt,
    required this.points,
  });

  factory HabitAchievement.fromJson(Map<String, dynamic> json) {
    return HabitAchievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      earnedAt: DateTime.parse(json['earnedAt']),
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'earnedAt': earnedAt.toIso8601String(),
      'points': points,
    };
  }
}

class HabitChallenge {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int targetDays;
  final int currentStreak;
  final List<String> participants;
  final bool isCompleted;

  HabitChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetDays,
    required this.currentStreak,
    required this.participants,
    required this.isCompleted,
  });

  factory HabitChallenge.fromJson(Map<String, dynamic> json) {
    return HabitChallenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      targetDays: json['targetDays'],
      currentStreak: json['currentStreak'],
      participants: List<String>.from(json['participants']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'targetDays': targetDays,
      'currentStreak': currentStreak,
      'participants': participants,
      'isCompleted': isCompleted,
    };
  }
} 