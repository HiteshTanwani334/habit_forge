import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit_model.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];
  List<HabitTask> _tasks = [];
  List<String> _categories = ['Personal', 'Work']; // Default categories

  List<Habit> get habits => _habits;
  List<HabitTask> get tasks => _tasks;

  HabitProvider() {
    _loadHabits();
    _loadTasks();
    _loadCategories();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      final List<dynamic> decodedHabits = json.decode(habitsJson);
      _habits = decodedHabits.map((habit) => Habit.fromJson(habit)).toList();
      notifyListeners();
    }
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decodedTasks = json.decode(tasksJson);
      _tasks = decodedTasks.map((task) => HabitTask.fromJson(task)).toList();
      notifyListeners();
    }
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList('categories');
    if (categoriesJson != null) {
      _categories = categoriesJson;
      notifyListeners();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = json.encode(_habits.map((habit) => habit.toJson()).toList());
    await prefs.setString('habits', habitsJson);
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(_tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  // Add a new habit
  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _saveHabits();
    notifyListeners();
  }

  // Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _saveHabits();
      notifyListeners();
    }
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((habit) => habit.id == habitId);
    _tasks.removeWhere((task) => task.habitId == habitId);
    await _saveHabits();
    await _saveTasks();
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String title, String description, DateTime dueDate, {String? habitId, required String category}) async {
    final task = HabitTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dueDate: dueDate,
      habitId: habitId,
      frequency: 1,
      frequencyType: 'daily',
      category: category,
      isCompleted: false,
      completedAt: null,
    );
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  // Update a task
  Future<void> updateTask(HabitTask task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    notifyListeners();
  }

  // Get tasks by category
  List<HabitTask> getTasksByCategory(String category) {
    if (category == "All") {
      return _tasks;
    }
    return _tasks.where((task) => task.category == category).toList();
  }

  // Get habits by category
  List<Habit> getHabitsByCategory(String category) {
    return _habits.where((habit) => habit.category == category).toList();
  }

  // Mark a task as completed
  Future<void> completeTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = HabitTask(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: true,
      completedAt: DateTime.now(),
      frequency: task.frequency,
      frequencyType: task.frequencyType,
      habitId: task.habitId,
    );
    await updateTask(updatedTask);
    
    // Update habit streak
    if (task.habitId != null) {
      final habit = _habits.firstWhere((h) => h.id == task.habitId);
      final updatedHabit = Habit(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        category: habit.category,
        createdAt: habit.createdAt,
        tasks: habit.tasks,
        streak: habit.streak + 1,
        isActive: habit.isActive,
      );
      await updateHabit(updatedHabit);
    }
  }

  // Get completion rate as double
  double getCompletionRate() {
    if (_tasks.isEmpty) return 0.0;
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    return (completedTasks / _tasks.length) * 100;
  }

  // Get category distribution as Map<String, double>
  Map<String, double> getCategoryDistribution() {
    if (_tasks.isEmpty) {
      return {};
    }

    final distribution = <String, double>{};
    
    // Count tasks per category
    for (var task in _tasks) {
      final category = task.category;
      distribution[category] = (distribution[category] ?? 0.0) + 1.0;
    }
    
    // Convert counts to percentages
    final total = distribution.values.reduce((a, b) => a + b);
    if (total > 0) {
      distribution.forEach((key, value) {
        distribution[key] = value / total;
      });
    }
    
    return distribution;
  }

  // Get habit streaks as Map<String, double>
  Map<String, double> getHabitStreaks() {
    if (_habits.isEmpty) {
      return {};
    }

    final streaks = <String, double>{};
    for (var habit in _habits) {
      if (habit.isActive) {
        streaks[habit.title] = habit.streak.toDouble();
      }
    }
    return streaks;
  }

  // Get all stats for the stats screen
  Map<String, dynamic> getStats() {
    final completionRate = getCompletionRate();
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final totalTasks = _tasks.length;
    final activeHabits = _habits.where((habit) => habit.isActive).length;
    final longestStreak = _habits.fold(0, (max, habit) => habit.streak > max ? habit.streak : max);

    return {
      'completionRate': completionRate,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'activeHabits': activeHabits,
      'longestStreak': longestStreak,
    };
  }

  // Refresh stats data
  Future<void> refreshStats() async {
    await _loadHabits();
    await _loadTasks();
    notifyListeners();
  }

  // Get weekly trends data
  Map<String, double> getWeeklyTrends() {
    if (_tasks.isEmpty) {
      return {};
    }

    final weeklyData = <String, double>{};
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    // Initialize all days of the week with 0.0
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    for (var day in days) {
      weeklyData[day] = 0.0;
    }

    // Calculate completion rate for each day
    for (var day = 0; day < 7; day++) {
      final date = weekStart.add(Duration(days: day));
      final dayTasks = _tasks.where((task) => 
        task.dueDate.year == date.year && 
        task.dueDate.month == date.month && 
        task.dueDate.day == date.day
      ).toList();

      if (dayTasks.isNotEmpty) {
        final completed = dayTasks.where((task) => task.isCompleted).length;
        weeklyData[days[day]] = completed / dayTasks.length;
      }
    }

    return weeklyData;
  }

  // Get task completion history
  List<Map<String, dynamic>> getTaskCompletionHistory() {
    return _tasks
        .where((task) => task.isCompleted && task.completedAt != null)
        .map((task) {
          String habitTitle = 'One-time Task';
          if (task.habitId != null) {
            final habitOpt = _habits.where((h) => h.id == task.habitId).toList();
            if (habitOpt.isNotEmpty) {
              habitTitle = habitOpt.first.title;
            }
          }
          
          return {
            'title': task.title,
            'habit': habitTitle,
            'completedAt': task.completedAt!,
          };
        })
        .toList()
      ..sort((a, b) => (b['completedAt'] as DateTime).compareTo(a['completedAt'] as DateTime));
  }

  // Get all categories
  List<String> getCategories() {
    return List.from(_categories);
  }

  // Add a new category
  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      _categories.add(category);
      await _saveCategories();
      notifyListeners();
    }
  }

  // Delete a category
  Future<void> deleteCategory(String category) async {
    // Don't delete if category is in use
    final isInUse = _tasks.any((task) => task.category == category) ||
        _habits.any((habit) => habit.category == category);
    
    if (isInUse) {
      throw Exception('Cannot delete category that is in use');
    }

    _categories.remove(category);
    await _saveCategories();
    notifyListeners();
  }
} 