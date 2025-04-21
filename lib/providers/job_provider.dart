import 'package:flutter/material.dart';
import '../services/job_service.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';

class JobProvider with ChangeNotifier {
  final JobService _jobService = JobService();
  
  bool _isLoading = false;
  String? _error;
  List<JobModel> _jobs = [];
  List<JobModel> _clientJobs = [];
  List<JobModel> _recommendedJobs = [];
  JobModel? _selectedJob;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<JobModel> get jobs => _jobs;
  List<JobModel> get clientJobs => _clientJobs;
  List<JobModel> get recommendedJobs => _recommendedJobs;
  JobModel? get selectedJob => _selectedJob;
  
  // Fetch all jobs
  Future<void> fetchAllJobs() async {
    _setLoading(true);
    _clearError();
    
    try {
      _jobs = await _jobService.getAllJobs();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch jobs: ${e.toString()}');
    }
  }
  
  // Fetch client jobs
  Future<void> fetchClientJobs(String clientId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _clientJobs = await _jobService.getJobsByClientId(clientId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch client jobs: ${e.toString()}');
    }
  }
  
  // Fetch job by ID
  Future<void> fetchJobById(String jobId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _selectedJob = await _jobService.getJobById(jobId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch job: ${e.toString()}');
    }
  }
  
  // Create job
  Future<bool> createJob(JobModel job) async {
    _setLoading(true);
    _clearError();
    
    try {
      final createdJob = await _jobService.createJob(job);
      _clientJobs.add(createdJob);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create job: ${e.toString()}');
      return false;
    }
  }
  
  // Update job
  Future<bool> updateJob(JobModel job) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedJob = await _jobService.updateJob(job);
      
      // Update in the lists
      final jobIndex = _jobs.indexWhere((j) => j.id == job.id);
      if (jobIndex >= 0) {
        _jobs[jobIndex] = updatedJob;
      }
      
      final clientJobIndex = _clientJobs.indexWhere((j) => j.id == job.id);
      if (clientJobIndex >= 0) {
        _clientJobs[clientJobIndex] = updatedJob;
      }
      
      if (_selectedJob?.id == job.id) {
        _selectedJob = updatedJob;
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update job: ${e.toString()}');
      return false;
    }
  }
  
  // Delete job
  Future<bool> deleteJob(String jobId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _jobService.deleteJob(jobId);
      
      // Remove from the lists
      _jobs.removeWhere((job) => job.id == jobId);
      _clientJobs.removeWhere((job) => job.id == jobId);
      
      if (_selectedJob?.id == jobId) {
        _selectedJob = null;
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete job: ${e.toString()}');
      return false;
    }
  }
  
  // Search jobs
  Future<void> searchJobs({
    String? keyword,
    List<String>? skills,
    String? location,
    String? jobType,
    String? locationType,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      _jobs = await _jobService.searchJobs(
        keyword: keyword,
        skills: skills,
        location: location,
        jobType: jobType,
        locationType: locationType,
      );
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search jobs: ${e.toString()}');
    }
  }
  
  // Get job recommendations
  Future<void> getJobRecommendations(UserModel freelancer) async {
    _setLoading(true);
    _clearError();
    
    try {
      _recommendedJobs = await _jobService.getJobRecommendations(freelancer);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to get job recommendations: ${e.toString()}');
    }
  }
  
  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
