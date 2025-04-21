import 'activity_streak.dart';

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
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['userType'],
      profileImageUrl: json['profileImageUrl'],
      location: json['location'],
      about: json['about'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      workExperience:
          json['workExperience'] != null
              ? (json['workExperience'] as List)
                  .map((e) => WorkExperience.fromJson(e))
                  .toList()
              : null,
      education:
          json['education'] != null
              ? (json['education'] as List)
                  .map((e) => Education.fromJson(e))
                  .toList()
              : null,
      certificates:
          json['certificates'] != null
              ? (json['certificates'] as List)
                  .map((e) => Certificate.fromJson(e))
                  .toList()
              : null,
      projects:
          json['projects'] != null
              ? (json['projects'] as List)
                  .map((e) => Project.fromJson(e))
                  .toList()
              : null,
      achievements:
          json['achievements'] != null
              ? (json['achievements'] as List)
                  .map((e) => Achievement.fromJson(e))
                  .toList()
              : null,
      socialLinks:
          json['socialLinks'] != null
              ? (json['socialLinks'] as List)
                  .map((e) => SocialLink.fromJson(e))
                  .toList()
              : null,
      careerGoals: json['careerGoals'],
      rating: json['rating']?.toDouble(),
      activityStreak:
          json['activityStreak'] != null
              ? ActivityStreak.fromJson(json['activityStreak'])
              : null,
      joinDate:
          json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      hourlyRate: json['hourlyRate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['userType'] = userType;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;
    if (location != null) data['location'] = location;
    if (about != null) data['about'] = about;
    if (skills != null) data['skills'] = skills;
    if (workExperience != null) {
      data['workExperience'] = workExperience!.map((e) => e.toJson()).toList();
    }
    if (education != null) {
      data['education'] = education!.map((e) => e.toJson()).toList();
    }
    if (certificates != null) {
      data['certificates'] = certificates!.map((e) => e.toJson()).toList();
    }
    if (projects != null) {
      data['projects'] = projects!.map((e) => e.toJson()).toList();
    }
    if (achievements != null) {
      data['achievements'] = achievements!.map((e) => e.toJson()).toList();
    }
    if (socialLinks != null) {
      data['socialLinks'] = socialLinks!.map((e) => e.toJson()).toList();
    }
    if (careerGoals != null) data['careerGoals'] = careerGoals;
    if (rating != null) data['rating'] = rating;
    if (activityStreak != null) {
      data['activityStreak'] = activityStreak!.toJson();
    }
    if (joinDate != null) data['joinDate'] = joinDate!.toIso8601String();
    if (hourlyRate != null) data['hourlyRate'] = hourlyRate;
    return data;
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
      expirationDate:
          json['expirationDate'] != null
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
      technologies:
          json['technologies'] != null
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
