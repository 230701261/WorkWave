import 'activity_streak.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String userType; // 'freelancer' or 'client'
  final String? profileImageUrl;
  final String? location;
  final String? about;
  final List<String>? skills;
  final List<WorkExperience>? workExperience;
  final List<Education>? education;
  final List<Certificate>? certificates;
  final List<Project>? projects;
  final List<Achievement>? achievements;
  final List<SocialLink>? socialLinks;
  final String? careerGoals;
  final double? rating;
  final ActivityStreak? activityStreak;
  final DateTime? joinDate;
  final double? hourlyRate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.profileImageUrl,
    this.location,
    this.about,
    this.skills,
    this.workExperience,
    this.education,
    this.certificates,
    this.projects,
    this.achievements,
    this.socialLinks,
    this.careerGoals,
    this.rating,
    this.activityStreak,
    this.joinDate,
    this.hourlyRate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      // Convert any List<Object?> to List<String> for skills
      List<String> parseSkills(dynamic skills) {
        if (skills == null) return [];
        if (skills is List) {
          return skills.map((e) => e?.toString() ?? '').toList();
        }
        if (skills is String) {
          return [skills];
        }
        return [];
      }

      return UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        userType: json['userType']?.toString() ?? 'freelancer',
        profileImageUrl: json['profileImageUrl']?.toString(),
        location: json['location']?.toString(),
        about: json['about']?.toString(),
        skills: parseSkills(json['skills']),
        workExperience: _parseList<WorkExperience>(
          json['workExperience'],
          (item) => WorkExperience.fromJson(Map<String, dynamic>.from(item)),
        ),
        education: _parseList<Education>(
          json['education'],
          (item) => Education.fromJson(Map<String, dynamic>.from(item)),
        ),
        certificates: _parseList<Certificate>(
          json['certificates'],
          (item) => Certificate.fromJson(Map<String, dynamic>.from(item)),
        ),
        projects: _parseList<Project>(
          json['projects'],
          (item) => Project.fromJson(Map<String, dynamic>.from(item)),
        ),
        achievements: _parseList<Achievement>(
          json['achievements'],
          (item) => Achievement.fromJson(Map<String, dynamic>.from(item)),
        ),
        socialLinks: _parseList<SocialLink>(
          json['socialLinks'],
          (item) => SocialLink.fromJson(Map<String, dynamic>.from(item)),
        ),
        careerGoals: json['careerGoals']?.toString(),
        rating: _parseDouble(json['rating']),
        activityStreak: json['activityStreak'] != null
            ? ActivityStreak.fromJson(
                Map<String, dynamic>.from(json['activityStreak']))
            : null,
        joinDate: _parseDateTime(json['joinDate']),
        hourlyRate: _parseDouble(json['hourlyRate']),
      );
    } catch (e) {
      print('Error parsing UserModel from JSON: $e');
      print('JSON data: $json');
      // Return an empty user model instead of throwing
      return UserModel.empty();
    }
  }

  // Helper method to parse lists with better type handling
  static List<T> _parseList<T>(dynamic list, T Function(dynamic) fromJson) {
    if (list == null) return [];
    if (list is List) {
      try {
        return list.map((item) {
          if (item is Map) {
            return fromJson(Map<String, dynamic>.from(item));
          }
          // Handle case where item might be a different type
          return fromJson({"data": item});
        }).toList();
      } catch (e) {
        print('Error parsing list of type $T: $e');
        return [];
      }
    }
    return [];
  }

  // Helper method to parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to parse DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing DateTime from string: $e');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType,
      'profileImageUrl': profileImageUrl ?? '',
      'location': location ?? '',
      'about': about ?? '',
      'skills': skills ?? [],
      'workExperience': workExperience?.map((e) => e.toJson()).toList() ?? [],
      'education': education?.map((e) => e.toJson()).toList() ?? [],
      'certificates': certificates?.map((e) => e.toJson()).toList() ?? [],
      'projects': projects?.map((e) => e.toJson()).toList() ?? [],
      'achievements': achievements?.map((e) => e.toJson()).toList() ?? [],
      'socialLinks': socialLinks?.map((e) => e.toJson()).toList() ?? [],
      'careerGoals': careerGoals ?? '',
      'rating': rating ?? 0.0,
      'activityStreak': activityStreak?.toJson(),
      'joinDate':
          joinDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'hourlyRate': hourlyRate ?? 0.0,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? userType,
    String? profileImageUrl,
    String? location,
    String? about,
    List<String>? skills,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<Certificate>? certificates,
    List<Project>? projects,
    List<Achievement>? achievements,
    List<SocialLink>? socialLinks,
    String? careerGoals,
    double? rating,
    ActivityStreak? activityStreak,
    DateTime? joinDate,
    double? hourlyRate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      about: about ?? this.about,
      skills: skills ?? this.skills,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      certificates: certificates ?? this.certificates,
      projects: projects ?? this.projects,
      achievements: achievements ?? this.achievements,
      socialLinks: socialLinks ?? this.socialLinks,
      careerGoals: careerGoals ?? this.careerGoals,
      rating: rating ?? this.rating,
      activityStreak: activityStreak ?? this.activityStreak,
      joinDate: joinDate ?? this.joinDate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
    );
  }

  // Alias for toJson to maintain compatibility with AuthService
  Map<String, dynamic> toMap() => toJson();

  // Factory method for creating a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel.fromJson(map);

  // Factory method to create a new user from Firebase Auth data
  factory UserModel.fromFirebaseAuth({
    required String uid,
    required String email,
    required String name,
    String userType = 'freelancer',
  }) {
    return UserModel(
      id: uid,
      email: email,
      name: name,
      userType: userType,
      joinDate: DateTime.now(),
    );
  }

  // Factory method to create an empty user
  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      userType: 'freelancer',
      profileImageUrl: null,
      location: null,
      about: null,
      skills: null,
      workExperience: null,
      education: null,
      certificates: null,
      projects: null,
      achievements: null,
      socialLinks: null,
      careerGoals: null,
      rating: null,
      activityStreak: null,
      joinDate: null,
      hourlyRate: null,
    );
  }

  // Check if the user model is empty
  bool get isEmpty => id.isEmpty;

  // Check if the user model is not empty
  bool get isNotEmpty => !isEmpty;
}

class WorkExperience {
  final String? id;
  final String title;
  final String company;
  final String location;
  final String locationType; // 'Remote', 'On-site', 'Hybrid'
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentlyWorking;
  final String? description;

  WorkExperience({
    this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.locationType,
    required this.startDate,
    this.endDate,
    this.isCurrentlyWorking = false,
    this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      locationType: json['locationType'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrentlyWorking: json['isCurrentlyWorking'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['company'] = company;
    data['location'] = location;
    data['locationType'] = locationType;
    data['startDate'] = startDate.toIso8601String();
    if (endDate != null) data['endDate'] = endDate!.toIso8601String();
    data['isCurrentlyWorking'] = isCurrentlyWorking;
    if (description != null) data['description'] = description;
    return data;
  }
}

class Education {
  final String? id;
  final String institution;
  final String degree;
  final String? fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentlyStudying;
  final String? description;

  Education({
    this.id,
    required this.institution,
    required this.degree,
    this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrentlyStudying = false,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      institution: json['institution'],
      degree: json['degree'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrentlyStudying: json['isCurrentlyStudying'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['institution'] = institution;
    data['degree'] = degree;
    if (fieldOfStudy != null) data['fieldOfStudy'] = fieldOfStudy;
    data['startDate'] = startDate.toIso8601String();
    if (endDate != null) data['endDate'] = endDate!.toIso8601String();
    data['isCurrentlyStudying'] = isCurrentlyStudying;
    if (description != null) data['description'] = description;
    return data;
  }
}

class Certificate {
  final String? id;
  final String name;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expirationDate;
  final String? credentialId;
  final String? credentialUrl;

  Certificate({
    this.id,
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expirationDate,
    this.credentialId,
    this.credentialUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'],
      name: json['name'],
      issuingOrganization: json['issuingOrganization'],
      issueDate: DateTime.parse(json['issueDate']),
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['issuingOrganization'] = issuingOrganization;
    data['issueDate'] = issueDate.toIso8601String();
    if (expirationDate != null) {
      data['expirationDate'] = expirationDate!.toIso8601String();
    }
    if (credentialId != null) data['credentialId'] = credentialId;
    if (credentialUrl != null) data['credentialUrl'] = credentialUrl;
    return data;
  }
}

class Project {
  final String? id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final String? description;
  final String? projectUrl;
  final List<String>? technologies;

  Project({
    this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    this.isOngoing = false,
    this.description,
    this.projectUrl,
    this.technologies,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isOngoing: json['isOngoing'] ?? false,
      description: json['description'],
      projectUrl: json['projectUrl'],
      technologies: json['technologies'] != null
          ? List<String>.from(json['technologies'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['startDate'] = startDate.toIso8601String();
    if (endDate != null) data['endDate'] = endDate!.toIso8601String();
    data['isOngoing'] = isOngoing;
    if (description != null) data['description'] = description;
    if (projectUrl != null) data['projectUrl'] = projectUrl;
    if (technologies != null) data['technologies'] = technologies;
    return data;
  }
}

class Achievement {
  final String? id;
  final String title;
  final DateTime date;
  final String? description;
  final String? issuer;

  Achievement({
    this.id,
    required this.title,
    required this.date,
    this.description,
    this.issuer,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      issuer: json['issuer'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['date'] = date.toIso8601String();
    if (description != null) data['description'] = description;
    if (issuer != null) data['issuer'] = issuer;
    return data;
  }
}

class SocialLink {
  final String? id;
  final String platform;
  final String url;

  SocialLink({this.id, required this.platform, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['id'],
      platform: json['platform'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['platform'] = platform;
    data['url'] = url;
    return data;
  }
}
