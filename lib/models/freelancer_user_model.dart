import '../../models/activity_streak.dart'; // Import the ActivityStreak model

class FreelancerUserModel {
  final String? id;
  final String name;
  final String? location;
  final String? profileImageUrl;
  final String? careerGoals;
  final String? about;
  final ActivityStreak? activityStreak; // Add this field

  FreelancerUserModel({
    this.id,
    required this.name,
    this.location,
    this.profileImageUrl,
    this.careerGoals,
    this.about,
    this.activityStreak, // Include in constructor
  });

  // Convert FreelancerUserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'careerGoals': careerGoals,
      'about': about,
      'activityStreak': activityStreak?.toJson(), // Serialize activityStreak
    };
  }

  // Create FreelancerUserModel from JSON
  factory FreelancerUserModel.fromJson(Map<String, dynamic> json) {
    return FreelancerUserModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      profileImageUrl: json['profileImageUrl'],
      careerGoals: json['careerGoals'],
      about: json['about'],
      activityStreak: json['activityStreak'] != null
          ? ActivityStreak.fromJson(json['activityStreak'])
          : null, // Deserialize activityStreak
    );
  }
}