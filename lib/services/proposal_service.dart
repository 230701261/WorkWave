import 'dart:async';
import 'package:uuid/uuid.dart';

import '../models/proposal_model.dart';
import '../services/job_service.dart';

class ProposalService {
  final JobService _jobService = JobService();
  
  // Mock proposals data
  final List<ProposalModel> _mockProposals = [
    ProposalModel(
      id: '1',
      jobId: '1',
      jobTitle: 'Flutter Mobile App Development',
      clientId: '2',
      clientName: 'Jane Client',
      freelancerId: '1',
      freelancerName: 'John Freelancer',
      freelancerProfileImage: '',
      coverLetter: 'I have extensive experience in Flutter development and would love to work on your fitness tracking app. I have built similar apps in the past and can deliver high-quality code within your timeline.',
      bidAmount: 4500,
      bidType: 'Fixed',
      estimatedDuration: 75, // days
      submittedDate: DateTime.now().subtract(Duration(days: 2)),
      status: 'Pending',
    ),
    ProposalModel(
      id: '2',
      jobId: '3',
      jobTitle: 'Full Stack Developer Needed',
      clientId: '2',
      clientName: 'Jane Client',
      freelancerId: '1',
      freelancerName: 'John Freelancer',
      freelancerProfileImage: '',
      coverLetter: 'I am a full stack developer with expertise in React and Node.js. I have built several e-commerce platforms and can help you create a scalable solution that meets your requirements.',
      bidAmount: 7800,
      bidType: 'Fixed',
      estimatedDuration: 110, // days
      submittedDate: DateTime.now().subtract(Duration(days: 5)),
      status: 'Accepted',
      clientFeedback: 'Great work so far, looking forward to the final product!',
      clientRating: 4.9,
    ),
  ];

  // Create a new proposal
  Future<ProposalModel> createProposal(ProposalModel proposal) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      final uuid = Uuid();
      final newProposal = proposal.copyWith(
        id: proposal.id.isEmpty ? uuid.v4() : proposal.id,
        submittedDate: DateTime.now(),
      );
      
      _mockProposals.add(newProposal);
      
      // Update job proposals count
      try {
        final job = await _jobService.getJobById(proposal.jobId);
        await _jobService.updateJob(job.copyWith(
          proposalsCount: job.proposalsCount + 1,
        ));
      } catch (e) {
        print('Failed to update job proposal count: ${e.toString()}');
      }
      
      return newProposal;
    } catch (e) {
      throw Exception('Failed to create proposal: ${e.toString()}');
    }
  }

  // Get proposals by job ID
  Future<List<ProposalModel>> getProposalsByJobId(String jobId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      return _mockProposals
          .where((proposal) => proposal.jobId == jobId)
          .toList()
        ..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
    } catch (e) {
      throw Exception('Failed to get proposals: ${e.toString()}');
    }
  }

  // Get proposals by freelancer ID
  Future<List<ProposalModel>> getProposalsByFreelancerId(String freelancerId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      return _mockProposals
          .where((proposal) => proposal.freelancerId == freelancerId)
          .toList()
        ..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
    } catch (e) {
      throw Exception('Failed to get freelancer proposals: ${e.toString()}');
    }
  }

  // Get proposals by client ID
  Future<List<ProposalModel>> getProposalsByClientId(String clientId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      return _mockProposals
          .where((proposal) => proposal.clientId == clientId)
          .toList()
        ..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
    } catch (e) {
      throw Exception('Failed to get client proposals: ${e.toString()}');
    }
  }

  // Get proposal by ID
  Future<ProposalModel> getProposalById(String proposalId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      final proposal = _mockProposals.firstWhere(
        (proposal) => proposal.id == proposalId,
        orElse: () => throw Exception('Proposal not found'),
      );
      
      return proposal;
    } catch (e) {
      throw Exception('Failed to get proposal: ${e.toString()}');
    }
  }

  // Update proposal
  Future<ProposalModel> updateProposal(ProposalModel proposal) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      final index = _mockProposals.indexWhere((p) => p.id == proposal.id);
      
      if (index == -1) {
        throw Exception('Proposal not found');
      }
      
      _mockProposals[index] = proposal;
      return proposal;
    } catch (e) {
      throw Exception('Failed to update proposal: ${e.toString()}');
    }
  }

  // Update proposal status
  Future<ProposalModel> updateProposalStatus({
    required String proposalId,
    required String status,
    String? clientFeedback,
    double? clientRating,
  }) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      final index = _mockProposals.indexWhere((p) => p.id == proposalId);
      
      if (index == -1) {
        throw Exception('Proposal not found');
      }
      
      final updatedProposal = _mockProposals[index].copyWith(
        status: status,
        clientFeedback: clientFeedback,
        clientRating: clientRating,
      );
      
      _mockProposals[index] = updatedProposal;
      return updatedProposal;
    } catch (e) {
      throw Exception('Failed to update proposal status: ${e.toString()}');
    }
  }

  // Delete proposal
  Future<void> deleteProposal(String proposalId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    try {
      final proposal = _mockProposals.firstWhere(
        (p) => p.id == proposalId,
        orElse: () => throw Exception('Proposal not found'),
      );
      
      _mockProposals.removeWhere((p) => p.id == proposalId);
      
      // Update job proposals count
      try {
        final job = await _jobService.getJobById(proposal.jobId);
        await _jobService.updateJob(job.copyWith(
          proposalsCount: job.proposalsCount > 0 ? job.proposalsCount - 1 : 0,
        ));
      } catch (e) {
        print('Failed to update job proposal count: ${e.toString()}');
      }
    } catch (e) {
      throw Exception('Failed to delete proposal: ${e.toString()}');
    }
  }
}
