import 'dart:async';
import 'package:uuid/uuid.dart';

import '../models/job_model.dart';
import '../models/user_model.dart';

class JobService {
  // Mock jobs data
  final List<JobModel> _mockJobs = [
    JobModel(
      id: '1',
      clientId: '2', // Jane Client
      clientName: 'Jane Client',
      clientProfileImage: '',
      title: 'Flutter Mobile App Development',
      description: 'Looking for an experienced Flutter developer to build a mobile application for a fitness tracking platform.',
      skills: ['Flutter', 'Dart', 'Firebase', 'UI/UX Design'],
      budget: 5000,
      budgetType: 'Fixed',
      jobType: 'Freelance',
      locationType: 'Remote',
      location: 'Anywhere',
      postedDate: DateTime.now().subtract(Duration(days: 3)),
      deadline: DateTime.now().add(Duration(days: 14)),
      proposalsCount: 7,
      viewsCount: 24,
      status: 'Active',
    ),
    JobModel(
      id: '2',
      clientId: '2', // Jane Client
      clientName: 'Jane Client',
      clientProfileImage: '',
      title: 'UI/UX Design for Web Dashboard',
      description: 'Need a talented UI/UX designer to create a modern and intuitive dashboard for a SaaS application.',
      skills: ['UI/UX Design', 'Figma', 'Web Design', 'Dashboard Design'],
      budget: 2000,
      budgetType: 'Fixed',
      jobType: 'Freelance',
      locationType: 'Remote',
      location: 'Anywhere',
      postedDate: DateTime.now().subtract(Duration(days: 5)),
      deadline: DateTime.now().add(Duration(days: 10)),
      proposalsCount: 12,
      viewsCount: 37,
      status: 'Active',
    ),
    JobModel(
      id: '3',
      clientId: '2', // Jane Client
      clientName: 'Jane Client',
      clientProfileImage: '',
      title: 'Full Stack Developer Needed',
      description: 'Looking for a full stack developer proficient in React and Node.js to build a scalable e-commerce platform.',
      skills: ['React', 'Node.js', 'MongoDB', 'Express', 'JavaScript'],
      budget: 8000,
      budgetType: 'Fixed',
      jobType: 'Contract',
      locationType: 'Remote',
      location: 'Anywhere',
      postedDate: DateTime.now().subtract(Duration(days: 7)),
      deadline: DateTime.now().add(Duration(days: 21)),
      proposalsCount: 16,
      viewsCount: 52,
      status: 'Active',
    ),
    JobModel(
      id: '4',
      clientId: '2', // Jane Client
      clientName: 'Jane Client',
      clientProfileImage: '',
      title: 'Mobile App Performance Optimization',
      description: 'Need a developer to optimize the performance of an existing Flutter mobile application.',
      skills: ['Flutter', 'Dart', 'Performance Optimization', 'Mobile Development'],
      budget: 1500,
      budgetType: 'Fixed',
      jobType: 'Freelance',
      locationType: 'Remote',
      location: 'Anywhere',
      postedDate: DateTime.now().subtract(Duration(days: 2)),
      deadline: DateTime.now().add(Duration(days: 7)),
      proposalsCount: 4,
      viewsCount: 18,
      status: 'Active',
    ),
    JobModel(
      id: '5',
      clientId: '2', // Jane Client
      clientName: 'Jane Client',
      clientProfileImage: '',
      title: 'Backend API Development with Node.js',
      description: 'Looking for a backend developer to create RESTful APIs for a mobile application.',
      skills: ['Node.js', 'Express', 'MongoDB', 'API Development', 'JavaScript'],
      budget: 3000,
      budgetType: 'Fixed',
      jobType: 'Freelance',
      locationType: 'Remote',
      location: 'Anywhere',
      postedDate: DateTime.now().subtract(Duration(days: 1)),
      deadline: DateTime.now().add(Duration(days: 30)),
      proposalsCount: 9,
      viewsCount: 27,
      status: 'Active',
    ),
  ];

  // Create a new job
  Future<JobModel> createJob(JobModel job) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      final uuid = Uuid();
      final newJob = job.copyWith(
        id: job.id.isEmpty ? uuid.v4() : job.id,
        postedDate: DateTime.now(),
      );
      
      _mockJobs.add(newJob);
      return newJob;
    } catch (e) {
      throw Exception('Failed to create job: ${e.toString()}');
    }
  }

  // Get all jobs
  Future<List<JobModel>> getAllJobs() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      return _mockJobs
          .where((job) => job.status == 'Active')
          .toList()
        ..sort((a, b) => b.postedDate.compareTo(a.postedDate));
    } catch (e) {
      throw Exception('Failed to get jobs: ${e.toString()}');
    }
  }

  // Get jobs by client ID
  Future<List<JobModel>> getJobsByClientId(String clientId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      return _mockJobs
          .where((job) => job.clientId == clientId)
          .toList()
        ..sort((a, b) => b.postedDate.compareTo(a.postedDate));
    } catch (e) {
      throw Exception('Failed to get client jobs: ${e.toString()}');
    }
  }

  // Get job by ID
  Future<JobModel> getJobById(String jobId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      final job = _mockJobs.firstWhere(
        (job) => job.id == jobId,
        orElse: () => throw Exception('Job not found'),
      );
      
      return job;
    } catch (e) {
      throw Exception('Failed to get job: ${e.toString()}');
    }
  }

  // Update job
  Future<JobModel> updateJob(JobModel job) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      final index = _mockJobs.indexWhere((j) => j.id == job.id);
      
      if (index == -1) {
        throw Exception('Job not found');
      }
      
      _mockJobs[index] = job;
      return job;
    } catch (e) {
      throw Exception('Failed to update job: ${e.toString()}');
    }
  }

  // Delete job
  Future<void> deleteJob(String jobId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      _mockJobs.removeWhere((job) => job.id == jobId);
    } catch (e) {
      throw Exception('Failed to delete job: ${e.toString()}');
    }
  }

  // Search jobs by keywords, skills, or location
  Future<List<JobModel>> searchJobs({
    String? keyword,
    List<String>? skills,
    String? location,
    String? jobType,
    String? locationType,
  }) async {
    await Future.delayed(Duration(milliseconds: 700)); // Simulate network delay
    try {
      List<JobModel> jobs = _mockJobs.where((job) => job.status == 'Active').toList();
      
      // Filter by job type
      if (jobType != null && jobType.isNotEmpty) {
        jobs = jobs.where((job) => job.jobType == jobType).toList();
      }
      
      // Filter by location type
      if (locationType != null && locationType.isNotEmpty) {
        jobs = jobs.where((job) => job.locationType == locationType).toList();
      }
      
      // Filter by keyword
      if (keyword != null && keyword.isNotEmpty) {
        final lowercaseKeyword = keyword.toLowerCase();
        jobs = jobs.where((job) {
          return job.title.toLowerCase().contains(lowercaseKeyword) ||
              job.description.toLowerCase().contains(lowercaseKeyword);
        }).toList();
      }
      
      // Filter by skills
      if (skills != null && skills.isNotEmpty) {
        jobs = jobs.where((job) {
          return skills.any((skill) => job.skills.contains(skill));
        }).toList();
      }
      
      // Filter by location
      if (location != null && location.isNotEmpty) {
        final lowercaseLocation = location.toLowerCase();
        jobs = jobs.where((job) {
          return job.location.toLowerCase().contains(lowercaseLocation);
        }).toList();
      }
      
      return jobs;
    } catch (e) {
      throw Exception('Failed to search jobs: ${e.toString()}');
    }
  }

  // Get job recommendations for a freelancer based on their skills
  Future<List<JobModel>> getJobRecommendations(UserModel freelancer) async {
    await Future.delayed(Duration(milliseconds: 700)); // Simulate network delay
    try {
      if (freelancer.skills == null || freelancer.skills!.isEmpty) {
        return [];
      }
      
      List<JobModel> jobs = _mockJobs
          .where((job) => job.status == 'Active')
          .toList()
        ..sort((a, b) => b.postedDate.compareTo(a.postedDate));
      
      // Sort jobs by matching skills
      jobs.sort((a, b) {
        int aMatches = a.skills.where((skill) => freelancer.skills!.contains(skill)).length;
        int bMatches = b.skills.where((skill) => freelancer.skills!.contains(skill)).length;
        return bMatches.compareTo(aMatches);
      });
      
      return jobs.take(10).toList();
    } catch (e) {
      throw Exception('Failed to get job recommendations: ${e.toString()}');
    }
  }
}
