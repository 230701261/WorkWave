import 'package:uuid/uuid.dart';

class ReviewModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String reviewerId; // Could be freelancer or client
  final String reviewerName;
  final String reviewerImage;
  final String revieweeId; // Could be freelancer or client
  final String revieweeName;
  final String revieweeImage;
  final double rating;
  final String comment;
  final DateTime reviewDate;

  ReviewModel({
    String? id,
    required this.jobId,
    required this.jobTitle,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerImage,
    required this.revieweeId,
    required this.revieweeName,
    required this.revieweeImage,
    required this.rating,
    required this.comment,
    required this.reviewDate,
  }) : id = id ?? Uuid().v4();

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      reviewerId: json['reviewerId'],
      reviewerName: json['reviewerName'],
      reviewerImage: json['reviewerImage'],
      revieweeId: json['revieweeId'],
      revieweeName: json['revieweeName'],
      revieweeImage: json['revieweeImage'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      reviewDate: DateTime.parse(json['reviewDate']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jobId'] = jobId;
    data['jobTitle'] = jobTitle;
    data['reviewerId'] = reviewerId;
    data['reviewerName'] = reviewerName;
    data['reviewerImage'] = reviewerImage;
    data['revieweeId'] = revieweeId;
    data['revieweeName'] = revieweeName;
    data['revieweeImage'] = revieweeImage;
    data['rating'] = rating;
    data['comment'] = comment;
    data['reviewDate'] = reviewDate.toIso8601String();
    return data;
  }

  ReviewModel copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? reviewerId,
    String? reviewerName,
    String? reviewerImage,
    String? revieweeId,
    String? revieweeName,
    String? revieweeImage,
    double? rating,
    String? comment,
    DateTime? reviewDate,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerImage: reviewerImage ?? this.reviewerImage,
      revieweeId: revieweeId ?? this.revieweeId,
      revieweeName: revieweeName ?? this.revieweeName,
      revieweeImage: revieweeImage ?? this.revieweeImage,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      reviewDate: reviewDate ?? this.reviewDate,
    );
  }
}
