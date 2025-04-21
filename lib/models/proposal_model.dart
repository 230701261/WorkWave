import 'package:uuid/uuid.dart';

class ProposalModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String clientId;
  final String clientName;
  final String freelancerId;
  final String freelancerName;
  final String freelancerProfileImage;
  final String coverLetter;
  final double bidAmount;
  final String bidType; // 'Fixed', 'Hourly'
  final int estimatedDuration; // In days or hours depending on bidType
  final DateTime submittedDate;
  final String status; // 'Pending', 'Accepted', 'Rejected'
  final String? clientFeedback;
  final double? clientRating;

  ProposalModel({
    String? id,
    required this.jobId,
    required this.jobTitle,
    required this.clientId,
    required this.clientName,
    required this.freelancerId,
    required this.freelancerName,
    required this.freelancerProfileImage,
    required this.coverLetter,
    required this.bidAmount,
    required this.bidType,
    required this.estimatedDuration,
    required this.submittedDate,
    required this.status,
    this.clientFeedback,
    this.clientRating,
  }) : id = id ?? Uuid().v4();

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'],
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      freelancerId: json['freelancerId'],
      freelancerName: json['freelancerName'],
      freelancerProfileImage: json['freelancerProfileImage'],
      coverLetter: json['coverLetter'],
      bidAmount: json['bidAmount'].toDouble(),
      bidType: json['bidType'],
      estimatedDuration: json['estimatedDuration'],
      submittedDate: DateTime.parse(json['submittedDate']),
      status: json['status'],
      clientFeedback: json['clientFeedback'],
      clientRating: json['clientRating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jobId'] = jobId;
    data['jobTitle'] = jobTitle;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['freelancerId'] = freelancerId;
    data['freelancerName'] = freelancerName;
    data['freelancerProfileImage'] = freelancerProfileImage;
    data['coverLetter'] = coverLetter;
    data['bidAmount'] = bidAmount;
    data['bidType'] = bidType;
    data['estimatedDuration'] = estimatedDuration;
    data['submittedDate'] = submittedDate.toIso8601String();
    data['status'] = status;
    if (clientFeedback != null) data['clientFeedback'] = clientFeedback;
    if (clientRating != null) data['clientRating'] = clientRating;
    return data;
  }

  ProposalModel copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? clientId,
    String? clientName,
    String? freelancerId,
    String? freelancerName,
    String? freelancerProfileImage,
    String? coverLetter,
    double? bidAmount,
    String? bidType,
    int? estimatedDuration,
    DateTime? submittedDate,
    String? status,
    String? clientFeedback,
    double? clientRating,
  }) {
    return ProposalModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      freelancerId: freelancerId ?? this.freelancerId,
      freelancerName: freelancerName ?? this.freelancerName,
      freelancerProfileImage: freelancerProfileImage ?? this.freelancerProfileImage,
      coverLetter: coverLetter ?? this.coverLetter,
      bidAmount: bidAmount ?? this.bidAmount,
      bidType: bidType ?? this.bidType,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      submittedDate: submittedDate ?? this.submittedDate,
      status: status ?? this.status,
      clientFeedback: clientFeedback ?? this.clientFeedback,
      clientRating: clientRating ?? this.clientRating,
    );
  }
}
