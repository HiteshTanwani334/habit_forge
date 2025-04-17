class Habit {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final List<HabitTask> tasks;
  final int streak;
  final bool isActive;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.tasks,
    this.streak = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'streak': streak,
      'isActive': isActive,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      tasks: (json['tasks'] as List).map((task) => HabitTask.fromJson(task)).toList(),
      streak: json['streak'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? createdAt,
    List<HabitTask>? tasks,
    int? streak,
    bool? isActive,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      tasks: tasks ?? this.tasks,
      streak: streak ?? this.streak,
      isActive: isActive ?? this.isActive,
    );
  }
}

class HabitTask {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final int frequency;
  final String frequencyType;
  final String? habitId;
  final String category;

  HabitTask({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    required this.frequency,
    required this.frequencyType,
    this.habitId,
    this.category = 'Personal',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'frequency': frequency,
      'frequencyType': frequencyType,
      'habitId': habitId,
      'category': category,
    };
  }

  factory HabitTask.fromJson(Map<String, dynamic> json) {
    return HabitTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      frequency: json['frequency'] ?? 1,
      frequencyType: json['frequencyType'] ?? 'daily',
      habitId: json['habitId'],
      category: json['category'] ?? 'Personal',
    );
  }

  HabitTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    int? frequency,
    String? frequencyType,
    String? habitId,
    String? category,
  }) {
    return HabitTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      frequency: frequency ?? this.frequency,
      frequencyType: frequencyType ?? this.frequencyType,
      habitId: habitId ?? this.habitId,
      category: category ?? this.category,
    );
  }
}
