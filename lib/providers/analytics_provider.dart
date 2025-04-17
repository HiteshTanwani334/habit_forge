import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_analytics_model.dart';
import '../models/habit_model.dart';
import 'habit_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class AnalyticsProvider with ChangeNotifier {
  HabitAnalytics? _analytics;
  List<HabitAchievement> _achievements = [];
  List<HabitChallenge> _challenges = [];
  final HabitProvider _habitProvider;

  AnalyticsProvider(this._habitProvider) {
    _loadAnalytics();
    _loadAchievements();
    _loadChallenges();
  }

  HabitAnalytics? get analytics => _analytics;
  List<HabitAchievement> get achievements => _achievements;
  List<HabitChallenge> get challenges => _challenges;

  Future<void> _loadAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final analyticsJson = prefs.getString('analytics');
    if (analyticsJson != null) {
      _analytics = HabitAnalytics.fromJson(jsonDecode(analyticsJson));
    } else {
      _analytics = await _calculateAnalytics();
    }
    notifyListeners();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString('achievements');
    if (achievementsJson != null) {
      final List<dynamic> decodedAchievements = jsonDecode(achievementsJson);
      _achievements = decodedAchievements
          .map((a) => HabitAchievement.fromJson(a))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _loadChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final challengesJson = prefs.getString('challenges');
    if (challengesJson != null) {
      final List<dynamic> decodedChallenges = jsonDecode(challengesJson);
      _challenges = decodedChallenges
          .map((c) => HabitChallenge.fromJson(c))
          .toList();
    }
    notifyListeners();
  }

  Future<HabitAnalytics> _calculateAnalytics() async {
    final habits = _habitProvider.habits;
    final tasks = _habitProvider.tasks;

    // Calculate weekly trend
    final weeklyTrend = <String, double>{};
    final now = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.month}/${date.day}';
      final completedTasks = tasks.where((task) {
        return task.isCompleted &&
            task.completedAt != null &&
            task.completedAt!.year == date.year &&
            task.completedAt!.month == date.month &&
            task.completedAt!.day == date.day;
      }).length;
      weeklyTrend[key] = tasks.isEmpty ? 0.0 : completedTasks / tasks.length;
    }

    // Calculate daily completion
    final dailyCompletion = <String, int>{};
    for (var i = 0; i < 7; i++) {
      final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i];
      final completedTasks = tasks.where((task) {
        return task.isCompleted &&
            task.completedAt != null &&
            task.completedAt!.weekday == i + 1;
      }).length;
      dailyCompletion[day] = completedTasks;
    }

    // Calculate time of day completion
    final timeOfDayCompletion = <String, double>{
      'Morning': 0.0,
      'Afternoon': 0.0,
      'Evening': 0.0,
      'Night': 0.0,
    };
    for (var task in tasks.where((t) => t.isCompleted && t.completedAt != null)) {
      final hour = task.completedAt!.hour;
      if (hour >= 5 && hour < 12) {
        timeOfDayCompletion['Morning'] = timeOfDayCompletion['Morning']! + 1.0;
      } else if (hour >= 12 && hour < 17) {
        timeOfDayCompletion['Afternoon'] = timeOfDayCompletion['Afternoon']! + 1.0;
      } else if (hour >= 17 && hour < 22) {
        timeOfDayCompletion['Evening'] = timeOfDayCompletion['Evening']! + 1.0;
      } else {
        timeOfDayCompletion['Night'] = timeOfDayCompletion['Night']! + 1.0;
      }
    }

    // Calculate category success rates
    final categorySuccessRates = <String, double>{};
    for (var habit in habits) {
      final categoryTasks = tasks.where((t) => t.habitId == habit.id).toList();
      if (categoryTasks.isNotEmpty) {
        final completedTasks = categoryTasks.where((t) => t.isCompleted).length;
        categorySuccessRates[habit.category] =
            completedTasks / categoryTasks.length;
      }
    }

    // Generate insights
    final insights = <HabitInsight>[
      HabitInsight(
        title: 'Best Performing Day',
        description: 'You complete most tasks on ${_getBestPerformingDay(dailyCompletion)}',
        type: 'performance',
        date: now,
      ),
      HabitInsight(
        title: 'Most Productive Time',
        description: 'You are most productive during ${_getMostProductiveTime(timeOfDayCompletion)}',
        type: 'productivity',
        date: now,
      ),
    ];

    // Generate recommendations
    final recommendations = <HabitRecommendation>[
      HabitRecommendation(
        title: 'Morning Routine',
        description: 'Consider adding a morning routine based on your success rate',
        category: 'Personal',
        confidence: 0.85,
        relatedHabits: ['Meditation', 'Exercise', 'Reading'],
      ),
    ];

    final analytics = HabitAnalytics(
      weeklyTrend: weeklyTrend,
      dailyCompletion: dailyCompletion,
      timeOfDayCompletion: timeOfDayCompletion,
      categorySuccessRates: categorySuccessRates,
      insights: insights,
      recommendations: recommendations,
    );

    // Save analytics
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('analytics', jsonEncode(analytics.toJson()));

    return analytics;
  }

  String _getBestPerformingDay(Map<String, int> dailyCompletion) {
    return dailyCompletion.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String _getMostProductiveTime(Map<String, double> timeOfDayCompletion) {
    return timeOfDayCompletion.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  Future<void> updateAnalytics() async {
    _analytics = await _calculateAnalytics();
    notifyListeners();
  }

  Future<void> addAchievement(HabitAchievement achievement) async {
    _achievements.add(achievement);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'achievements',
      jsonEncode(_achievements.map((a) => a.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> addChallenge(HabitChallenge challenge) async {
    _challenges.add(challenge);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'challenges',
      jsonEncode(_challenges.map((c) => c.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> updateChallengeProgress(String challengeId, int newStreak) async {
    final challenge = _challenges.firstWhere((c) => c.id == challengeId);
    final updatedChallenge = HabitChallenge(
      id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
      targetDays: challenge.targetDays,
      currentStreak: newStreak,
      participants: challenge.participants,
      isCompleted: newStreak >= challenge.targetDays,
    );
    _challenges[_challenges.indexWhere((c) => c.id == challengeId)] =
        updatedChallenge;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'challenges',
      jsonEncode(_challenges.map((c) => c.toJson()).toList()),
    );
    notifyListeners();
  }
} 