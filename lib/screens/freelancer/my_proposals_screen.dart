import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/proposal_provider.dart';
import '../../widgets/proposal_card.dart';
import '../../widgets/custom_navbar.dart';

class MyProposalsScreen extends StatefulWidget {
  const MyProposalsScreen({super.key});

  @override
  _MyProposalsScreenState createState() => _MyProposalsScreenState();
}

class _MyProposalsScreenState extends State<MyProposalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadProposals();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadProposals() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final proposalProvider = Provider.of<ProposalProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await proposalProvider.fetchFreelancerProposals(authProvider.currentUser!.id);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final proposalProvider = Provider.of<ProposalProvider>(context);
    
    if (authProvider.currentUser == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Proposals'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppThemes.primaryColor,
          unselectedLabelColor: AppThemes.textSecondaryColor,
          indicatorColor: AppThemes.primaryColor,
          tabs: [
            Tab(text: 'All Proposals'),
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProposals,
        child: TabBarView(
          controller: _tabController,
          children: [
            // All Proposals
            _buildProposalsList(
              proposals: proposalProvider.freelancerProposals,
              isLoading: proposalProvider.isLoading,
              emptyMessage: 'You haven\'t submitted any proposals yet.',
            ),
            
            // Pending Proposals
            _buildProposalsList(
              proposals: proposalProvider.freelancerProposals
                  .where((p) => p.status == 'Pending')
                  .toList(),
              isLoading: proposalProvider.isLoading,
              emptyMessage: 'No pending proposals.',
            ),
            
            // Accepted Proposals
            _buildProposalsList(
              proposals: proposalProvider.freelancerProposals
                  .where((p) => p.status == 'Accepted')
                  .toList(),
              isLoading: proposalProvider.isLoading,
              emptyMessage: 'No accepted proposals.',
            ),
            
            // Rejected Proposals
            _buildProposalsList(
              proposals: proposalProvider.freelancerProposals
                  .where((p) => p.status == 'Rejected')
                  .toList(),
              isLoading: proposalProvider.isLoading,
              emptyMessage: 'No rejected proposals.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 2,
        user: authProvider.currentUser!,
      ),
    );
  }
  
  Widget _buildProposalsList({
    required List<dynamic> proposals,
    required bool isLoading,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (proposals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: AppThemes.textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: AppThemes.bodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(Routes.findJobs);
              },
              icon: Icon(Icons.search),
              label: Text('Find Jobs'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        final proposal = proposals[index];
        return ProposalCard(
          proposal: proposal,
          onTap: () {
            // Navigate to proposal details
            // Get.toNamed(Routes.proposalDetails, arguments: proposal.id);
          },
        );
      },
    );
  }
}
