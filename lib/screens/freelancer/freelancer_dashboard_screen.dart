import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/proposal_provider.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/job_card.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/custom_drawer.dart';

class FreelancerDashboardScreen extends StatefulWidget {
  const FreelancerDashboardScreen({super.key});

  @override
  _FreelancerDashboardScreenState createState() => _FreelancerDashboardScreenState();
}

class _FreelancerDashboardScreenState extends State<FreelancerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final proposalProvider = Provider.of<ProposalProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await proposalProvider.fetchFreelancerProposals(authProvider.currentUser!.id);
      await jobProvider.getJobRecommendations(authProvider.currentUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
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
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Get.toNamed(Routes.findJobs);
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      drawer: CustomDrawer(user: authProvider.currentUser!),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top stats cards
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Active Proposals',
                      value: proposalProvider.pendingProposalsCount.toString(),
                      subtitle: 'View All',
                      onTap: () {
                        Get.toNamed(Routes.myProposals);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Total Earnings',
                      value: '\$0.00', // This would come from a real earnings service
                      subtitle: 'View Details',
                      onTap: () {
                        Get.toNamed(Routes.earnings);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Completed Jobs',
                      value: proposalProvider.acceptedProposalsCount.toString(),
                      subtitle: 'View History',
                      onTap: () {
                        // Navigate to completed jobs
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Client Rating',
                      value: authProvider.currentUser!.rating?.toString() ?? 'N/A',
                      subtitle: 'View Reviews',
                      onTap: () {
                        // Navigate to reviews
                      },
                    ),
                  ),
                ],
              ),
              
              // Recent Job Activity
              const SizedBox(height: 24),
              Text(
                'Recent Job Activity',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 12),
              
              if (proposalProvider.isLoading)
                Center(child: CircularProgressIndicator())
              else if (proposalProvider.freelancerProposals.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'No recent job activity. Start applying to jobs to see your activity here.',
                          style: AppThemes.bodyStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: proposalProvider.freelancerProposals.length > 3
                      ? 3
                      : proposalProvider.freelancerProposals.length,
                  itemBuilder: (context, index) {
                    final proposal = proposalProvider.freelancerProposals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(proposal.jobTitle),
                        subtitle: Text('Status: ${proposal.status}'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Navigate to proposal details
                        },
                      ),
                    );
                  },
                ),
              
              // Recommended Jobs
              const SizedBox(height: 24),
              Text(
                'Recommended Jobs',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 12),
              
              if (jobProvider.isLoading)
                Center(child: CircularProgressIndicator())
              else if (jobProvider.recommendedJobs.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'No recommended jobs available at the moment.',
                          style: AppThemes.bodyStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: jobProvider.recommendedJobs.length > 3
                      ? 3
                      : jobProvider.recommendedJobs.length,
                  itemBuilder: (context, index) {
                    final job = jobProvider.recommendedJobs[index];
                    return JobCard(
                      job: job,
                      onTap: () {
                        // Navigate to job details
                      },
                    );
                  },
                ),
              
              // Recent Messages
              const SizedBox(height: 24),
              Text(
                'Recent Messages',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'No recent messages.',
                        style: AppThemes.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 0,
        user: authProvider.currentUser!,
      ),
    );
  }
}
