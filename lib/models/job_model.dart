import 'package:uuid/uuid.dart';

class JobModel {
  final String id;
  final String clientId;
  final String clientName;
  final String clientProfileImage;
  final String title;
  final String description;
  final List<String> skills;
  final String jobType; // 'Full-time', 'Part-time', 'Contract', 'Freelance'
  final String locationType; // 'Remote', 'On-site', 'Hybrid'
  final String location;
  final double? budget;
  final String? budgetType; // 'Fixed', 'Hourly'
  final DateTime postedDate;
  final DateTime? deadline;
  final String status; // 'Active', 'Completed', 'Cancelled'
  final int proposalsCount;
  final int viewsCount;

  JobModel({
    String? id,
    required this.clientId,
    required this.clientName,
    required this.clientProfileImage,
    required this.title,
    required this.description,
    required this.skills,
    required this.jobType,
    required this.locationType,
    required this.location,
    this.budget,
    this.budgetType,
    required this.postedDate,
    this.deadline,
    required this.status,
    this.proposalsCount = 0,
    this.viewsCount = 0,
  }) : id = id ?? Uuid().v4();

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientProfileImage: json['clientProfileImage'],
      title: json['title'],
      description: json['description'],
      skills: List<String>.from(json['skills']),
      jobType: json['jobType'],
      locationType: json['locationType'],
      location: json['location'],
      budget: json['budget']?.toDouble(),
      budgetType: json['budgetType'],
      postedDate: DateTime.parse(json['postedDate']),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      status: json['status'],
      proposalsCount: json['proposalsCount'] ?? 0,
      viewsCount: json['viewsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['clientProfileImage'] = clientProfileImage;
    data['title'] = title;
    data['description'] = description;
    data['skills'] = skills;
    data['jobType'] = jobType;
    data['locationType'] = locationType;
    data['location'] = location;
    if (budget != null) data['budget'] = budget;
    if (budgetType != null) data['budgetType'] = budgetType;
    data['postedDate'] = postedDate.toIso8601String();
    if (deadline != null) data['deadline'] = deadline!.toIso8601String();
    data['status'] = status;
    data['proposalsCount'] = proposalsCount;
    data['viewsCount'] = viewsCount;
    return data;
  }

  JobModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientProfileImage,
    String? title,
    String? description,
    List<String>? skills,
    String? jobType,
    String? locationType,
    String? location,
    double? budget,
    String? budgetType,
    DateTime? postedDate,
    DateTime? deadline,
    String? status,
    int? proposalsCount,
    int? viewsCount,
  }) {
    return JobModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientProfileImage: clientProfileImage ?? this.clientProfileImage,
      title: title ?? this.title,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      jobType: jobType ?? this.jobType,
      locationType: locationType ?? this.locationType,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      budgetType: budgetType ?? this.budgetType,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      viewsCount: viewsCount ?? this.viewsCount,
    );
  }
}
