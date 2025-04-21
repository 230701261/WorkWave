import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../models/user_model.dart';
import '../models/review_model.dart';
import '../services/auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  
  // Mock reviews data
  final List<ReviewModel> _mockReviews = [
    ReviewModel(
      id: '1',
      jobId: '2',
      jobTitle: 'UI/UX Design for Web Dashboard',
      reviewerId: '2', // Jane Client
      reviewerName: 'Jane Client',
      reviewerImage: '',
      revieweeId: '1', // John Freelancer
      revieweeName: 'John Freelancer',
      revieweeImage: '',
      rating: 4.8,
      comment: 'John delivered exceptional work on our UI/UX project. His designs were intuitive, visually appealing, and exactly what we were looking for. I highly recommend him for any design work.',
      reviewDate: DateTime.now().subtract(Duration(days: 30)),
    ),
    ReviewModel(
      id: '2',
      jobId: '1',
      jobTitle: 'Flutter Mobile App Development',
      reviewerId: '1', // John Freelancer
      reviewerName: 'John Freelancer',
      reviewerImage: '',
      revieweeId: '2', // Jane Client
      revieweeName: 'Jane Client',
      revieweeImage: '',
      rating: 4.9,
      comment: 'Jane was a pleasure to work with. She provided clear requirements, was responsive to questions, and paid promptly. I would definitely work with her again.',
      reviewDate: DateTime.now().subtract(Duration(days: 15)),
    ),
  ];

  // Get user by ID
  Future<UserModel> getUserById(String userId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      final user = await _authService.getUserById(userId);
      
      if (user == null) {
        throw Exception('User not found');
      }
      
      return user;
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  // Update user profile
  Future<UserModel> updateUserProfile(UserModel user) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // This is a mock implementation that would normally update the user in Firestore
      // Instead, we'll update the user in our AuthService
      final authService = AuthService();
      final users = authService._mockUsers;
      
      final index = users.indexWhere((u) => u.id == user.id);
      if (index == -1) {
        throw Exception('User not found');
      }
      
      users[index] = user;
      return user;
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // Upload profile image
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
    try {
      String fileName = path.basename(imageFile.path);
      String fileExtension = path.extension(fileName);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create a mock image URL (in a real app, this would be a URL from Firebase Storage)
      String imageUrl = 'https://mock-storage.example.com/profile_images/${userId}_$timestamp$fileExtension';
      
      // Update user profile with new image URL
      final user = await getUserById(userId);
      final updatedUser = user.copyWith(profileImageUrl: imageUrl);
      await updateUserProfile(updatedUser);
      
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }

  // Add work experience
  Future<UserModel> addWorkExperience(String userId, WorkExperience experience) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Add new experience
      List<WorkExperience> workExperience = user.workExperience ?? [];
      workExperience.add(experience);
      
      // Update user
      UserModel updatedUser = user.copyWith(workExperience: workExperience);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to add work experience: ${e.toString()}');
    }
  }

  // Add education
  Future<UserModel> addEducation(String userId, Education education) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Add new education
      List<Education> userEducation = user.education ?? [];
      userEducation.add(education);
      
      // Update user
      UserModel updatedUser = user.copyWith(education: userEducation);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to add education: ${e.toString()}');
    }
  }

  // Add certificate
  Future<UserModel> addCertificate(String userId, Certificate certificate) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Add new certificate
      List<Certificate> certificates = user.certificates ?? [];
      certificates.add(certificate);
      
      // Update user
      UserModel updatedUser = user.copyWith(certificates: certificates);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to add certificate: ${e.toString()}');
    }
  }

  // Add project
  Future<UserModel> addProject(String userId, Project project) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Add new project
      List<Project> projects = user.projects ?? [];
      projects.add(project);
      
      // Update user
      UserModel updatedUser = user.copyWith(projects: projects);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to add project: ${e.toString()}');
    }
  }

  // Add achievement
  Future<UserModel> addAchievement(String userId, Achievement achievement) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Add new achievement
      List<Achievement> achievements = user.achievements ?? [];
      achievements.add(achievement);
      
      // Update user
      UserModel updatedUser = user.copyWith(achievements: achievements);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to add achievement: ${e.toString()}');
    }
  }

  // Add social link
  Future<UserModel> addSocialLink(String userId, SocialLink socialLink) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Add new social link
      List<SocialLink> socialLinks = user.socialLinks ?? [];
      socialLinks.add(socialLink);
      
      // Update user
      UserModel updatedUser = user.copyWith(socialLinks: socialLinks);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to add social link: ${e.toString()}');
    }
  }

  // Update user skills
  Future<UserModel> updateUserSkills(String userId, List<String> skills) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Update skills
      UserModel updatedUser = user.copyWith(skills: skills);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update skills: ${e.toString()}');
    }
  }

  // Update user's activity streak
  Future<UserModel> updateActivityStreak(String userId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Get current user
      UserModel user = await getUserById(userId);
      
      // Get current date (UTC)
      final String today = DateTime.now().toUtc().toString().split(' ')[0];
      
      // Get or create activity streak
      ActivityStreak streak = user.activityStreak ?? ActivityStreak(
        currentStreak: 0,
        maxStreak: 0,
        activityCalendar: {},
      );
      
      // Update calendar
      Map<String, bool> calendar = Map<String, bool>.from(streak.activityCalendar);
      if (calendar.containsKey(today)) {
        // Already logged activity today
        return user;
      }
      
      // Add today's activity
      calendar[today] = true;
      
      // Calculate streak
      int currentStreak = streak.currentStreak;
      
      // Check if yesterday has activity
      final String yesterday = DateTime.now().toUtc().subtract(const Duration(days: 1)).toString().split(' ')[0];
      if (calendar.containsKey(yesterday) && calendar[yesterday] == true) {
        currentStreak++; // Increment streak
      } else {
        currentStreak = 1; // Reset streak
      }
      
      // Update max streak if needed
      int maxStreak = streak.maxStreak;
      if (currentStreak > maxStreak) {
        maxStreak = currentStreak;
      }
      
      // Create updated streak
      ActivityStreak updatedStreak = ActivityStreak(
        currentStreak: currentStreak,
        maxStreak: maxStreak,
        activityCalendar: calendar,
      );
      
      // Update user
      UserModel updatedUser = user.copyWith(activityStreak: updatedStreak);
      await updateUserProfile(updatedUser);
      
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update activity streak: ${e.toString()}');
    }
  }

  // Get freelancer reviews
  Future<List<ReviewModel>> getFreelancerReviews(String freelancerId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      return _mockReviews
          .where((review) => review.revieweeId == freelancerId)
          .toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
    } catch (e) {
      throw Exception('Failed to get freelancer reviews: ${e.toString()}');
    }
  }

  // Get client reviews
  Future<List<ReviewModel>> getClientReviews(String clientId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      return _mockReviews
          .where((review) => review.revieweeId == clientId)
          .toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
    } catch (e) {
      throw Exception('Failed to get client reviews: ${e.toString()}');
    }
  }

  // Add review
  Future<ReviewModel> addReview(ReviewModel review) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      // Add review to mock reviews
      _mockReviews.add(review);
      
      // Calculate average rating for reviewee
      List<ReviewModel> reviews = _mockReviews
          .where((r) => r.revieweeId == review.revieweeId)
          .toList();
      
      double averageRating = 0;
      if (reviews.isNotEmpty) {
        double totalRating = reviews.fold(0, (sum, r) => sum + r.rating);
        averageRating = totalRating / reviews.length;
      }
      
      // Update user's rating
      final user = await getUserById(review.revieweeId);
      final updatedUser = user.copyWith(rating: averageRating);
      await updateUserProfile(updatedUser);
      
      return review;
    } catch (e) {
      throw Exception('Failed to add review: ${e.toString()}');
    }
  }
}
