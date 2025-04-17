class Reward {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final bool isClaimed;
  final DateTime? claimedAt;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    this.isClaimed = false,
    this.claimedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsRequired': pointsRequired,
      'isClaimed': isClaimed,
      'claimedAt': claimedAt?.toIso8601String(),
    };
  }

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      pointsRequired: json['pointsRequired'],
      isClaimed: json['isClaimed'] ?? false,
      claimedAt: json['claimedAt'] != null ? DateTime.parse(json['claimedAt']) : null,
    );
  }

  Reward copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsRequired,
    bool? isClaimed,
    DateTime? claimedAt,
  }) {
    return Reward(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      isClaimed: isClaimed ?? this.isClaimed,
      claimedAt: claimedAt ?? this.claimedAt,
    );
  }
} 