class ActivityStreak {
  final int currentStreak;
  final int maxStreak;
  final Map<String, bool> activityCalendar;

  ActivityStreak({
    required this.currentStreak,
    required this.maxStreak,
    required this.activityCalendar,
  });

  // Optional: Add fromJson and toJson for serialization if needed
  factory ActivityStreak.fromJson(Map<String, dynamic> json) {
    return ActivityStreak(
      currentStreak: json['currentStreak'] ?? 0,
      maxStreak: json['maxStreak'] ?? 0,
      activityCalendar: Map<String, bool>.from(json['activityCalendar'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'activityCalendar': activityCalendar,
    };
  }
}