class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? habitId;
  final int priority; // 1: Low, 2: Medium, 3: High
  final List<String> tags;
  final bool isRecurring;
  final String? recurrencePattern; // daily, weekly, monthly
  final int? reminderMinutesBefore;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.habitId,
    this.priority = 2,
    this.tags = const [],
    this.isRecurring = false,
    this.recurrencePattern,
    this.reminderMinutesBefore,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    String? habitId,
    int? priority,
    List<String>? tags,
    bool? isRecurring,
    String? recurrencePattern,
    int? reminderMinutesBefore,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      habitId: habitId ?? this.habitId,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'habitId': habitId,
      'priority': priority,
      'tags': tags,
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
      'reminderMinutesBefore': reminderMinutesBefore,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      habitId: json['habitId'],
      priority: json['priority'],
      tags: List<String>.from(json['tags']),
      isRecurring: json['isRecurring'],
      recurrencePattern: json['recurrencePattern'],
      reminderMinutesBefore: json['reminderMinutesBefore'],
    );
  }
}
