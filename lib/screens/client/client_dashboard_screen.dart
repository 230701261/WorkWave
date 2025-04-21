import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/custom_drawer.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  _ClientDashboardScreenState createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await jobProvider.fetchClientJobs(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    
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
              // TODO: Implement search
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
                      title: 'Posted Jobs',
                      value: jobProvider.clientJobs.length.toString(),
                      subtitle: 'View All',
                      onTap: () {
                        Get.toNamed(Routes.myJobs);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Active Projects',
                      value: '0',
                      subtitle: 'View Details',
                      onTap: () {
                        // TODO: Navigate to active projects
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
                      title: 'Total Payments',
                      value: '\$0.00',
                      subtitle: 'View History',
                      onTap: () {
                        Get.toNamed(Routes.payments);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Freelancer Ratings',
                      value: 'N/A',
                      subtitle: 'View Reviews',
                      onTap: () {
                        // TODO: Navigate to reviews
                      },
                    ),
                  ),
                ],
              ),
              
              // Recent Project Activity
              const SizedBox(height: 24),
              Text(
                'Recent Project Activity',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'No recent project activity.',
                        style: AppThemes.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Recommended Freelancers
              const SizedBox(height: 24),
              Text(
                'Recommended Freelancers',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'No recommended freelancers available.',
                        style: AppThemes.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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
              
              // Post a new job button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.postJob);
                  },
                  icon: Icon(Icons.add),
                  label: Text('Post a New Job'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
