import 'package:flutter/material.dart';
import '../services/proposal_service.dart';
import '../models/proposal_model.dart';

class ProposalProvider with ChangeNotifier {
  final ProposalService _proposalService = ProposalService();
  
  bool _isLoading = false;
  String? _error;
  List<ProposalModel> _freelancerProposals = [];
  List<ProposalModel> _clientProposals = [];
  List<ProposalModel> _jobProposals = [];
  ProposalModel? _selectedProposal;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ProposalModel> get freelancerProposals => _freelancerProposals;
  List<ProposalModel> get clientProposals => _clientProposals;
  List<ProposalModel> get jobProposals => _jobProposals;
  ProposalModel? get selectedProposal => _selectedProposal;
  
  // Count proposals by status
  int get pendingProposalsCount => _freelancerProposals.where((p) => p.status == 'Pending').length;
  int get acceptedProposalsCount => _freelancerProposals.where((p) => p.status == 'Accepted').length;
  int get rejectedProposalsCount => _freelancerProposals.where((p) => p.status == 'Rejected').length;
  
  // Fetch freelancer proposals
  Future<void> fetchFreelancerProposals(String freelancerId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _freelancerProposals = await _proposalService.getProposalsByFreelancerId(freelancerId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch freelancer proposals: ${e.toString()}');
    }
  }
  
  // Fetch client proposals
  Future<void> fetchClientProposals(String clientId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _clientProposals = await _proposalService.getProposalsByClientId(clientId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch client proposals: ${e.toString()}');
    }
  }
  
  // Fetch job proposals
  Future<void> fetchJobProposals(String jobId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _jobProposals = await _proposalService.getProposalsByJobId(jobId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch job proposals: ${e.toString()}');
    }
  }
  
  // Fetch proposal by ID
  Future<void> fetchProposalById(String proposalId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _selectedProposal = await _proposalService.getProposalById(proposalId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch proposal: ${e.toString()}');
    }
  }
  
  // Create proposal
  Future<bool> createProposal(ProposalModel proposal) async {
    _setLoading(true);
    _clearError();
    
    try {
      final createdProposal = await _proposalService.createProposal(proposal);
      _freelancerProposals.add(createdProposal);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create proposal: ${e.toString()}');
      return false;
    }
  }
  
  // Update proposal
  Future<bool> updateProposal(ProposalModel proposal) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedProposal = await _proposalService.updateProposal(proposal);
      
      // Update in the lists
      _updateProposalInLists(updatedProposal);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update proposal: ${e.toString()}');
      return false;
    }
  }
  
  // Update proposal status
  Future<bool> updateProposalStatus({
    required String proposalId,
    required String status,
    String? clientFeedback,
    double? clientRating,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedProposal = await _proposalService.updateProposalStatus(
        proposalId: proposalId,
        status: status,
        clientFeedback: clientFeedback,
        clientRating: clientRating,
      );
      
      // Update in the lists
      _updateProposalInLists(updatedProposal);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update proposal status: ${e.toString()}');
      return false;
    }
  }
  
  // Delete proposal
  Future<bool> deleteProposal(String proposalId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _proposalService.deleteProposal(proposalId);
      
      // Remove from the lists
      _freelancerProposals.removeWhere((p) => p.id == proposalId);
      _clientProposals.removeWhere((p) => p.id == proposalId);
      _jobProposals.removeWhere((p) => p.id == proposalId);
      
      if (_selectedProposal?.id == proposalId) {
        _selectedProposal = null;
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete proposal: ${e.toString()}');
      return false;
    }
  }
  
  // Helper methods
  void _updateProposalInLists(ProposalModel proposal) {
    // Update in freelancer proposals
    final freelancerIndex = _freelancerProposals.indexWhere((p) => p.id == proposal.id);
    if (freelancerIndex >= 0) {
      _freelancerProposals[freelancerIndex] = proposal;
    }
    
    // Update in client proposals
    final clientIndex = _clientProposals.indexWhere((p) => p.id == proposal.id);
    if (clientIndex >= 0) {
      _clientProposals[clientIndex] = proposal;
    }
    
    // Update in job proposals
    final jobIndex = _jobProposals.indexWhere((p) => p.id == proposal.id);
    if (jobIndex >= 0) {
      _jobProposals[jobIndex] = proposal;
    }
    
    // Update selected proposal
    if (_selectedProposal?.id == proposal.id) {
      _selectedProposal = proposal;
    }
  }
  
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
