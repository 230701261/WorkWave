import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/job_card.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/custom_snackbar.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  _MyJobsScreenState createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentTab = 'Active';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadData();
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _currentTab = 'Active';
            break;
          case 1:
            _currentTab = 'Pending';
            break;
          case 2:
            _currentTab = 'Completed';
            break;
        }
      });
    }
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
    
    // Filter jobs by status
    final activeJobs = jobProvider.clientJobs.where((job) => job.status == 'Active').toList();
    final pendingJobs = jobProvider.clientJobs.where((job) => job.status == 'Pending').toList();
    final completedJobs = jobProvider.clientJobs.where((job) => job.status == 'Completed').toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Jobs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Active Jobs Tab
            _buildJobsList(activeJobs, jobProvider.isLoading, 'No active jobs'),
            
            // Pending Jobs Tab
            _buildJobsList(pendingJobs, jobProvider.isLoading, 'No pending jobs'),
            
            // Completed Jobs Tab
            _buildJobsList(completedJobs, jobProvider.isLoading, 'No completed jobs'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.postJob);
        },
        tooltip: 'Post a new job',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 2,
        user: authProvider.currentUser!,
      ),
    );
  }
  
  Widget _buildJobsList(List<dynamic> jobs, bool isLoading, String emptyMessage) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
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
                Get.toNamed(Routes.postJob);
              },
              icon: Icon(Icons.add),
              label: Text('Post a New Job'),
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
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return JobCard(
          job: job,
          isClientView: true,
          onTap: () {
            _showJobOptions(job);
          },
        );
      },
    );
  }
  
  void _showJobOptions(dynamic job) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to job details
                },
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('View Proposals (${job.proposalsCount})'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to job proposals
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Job'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit job
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('Cancel Job', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmCancelJob(job);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _confirmCancelJob(dynamic job) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancel Job'),
          content: Text('Are you sure you want to cancel this job? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No, Keep It'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                
                final jobProvider = Provider.of<JobProvider>(context, listen: false);
                final success = await jobProvider.updateJob(
                  job.copyWith(status: 'Cancelled'),
                );
                
                if (success) {
                  CustomSnackbar.show(
                    context: context,
                    message: 'Job cancelled successfully',
                    type: SnackbarType.success,
                  );
                  _loadData();
                } else {
                  CustomSnackbar.show(
                    context: context,
                    message: jobProvider.error ?? 'Failed to cancel job',
                    type: SnackbarType.error,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Yes, Cancel It'),
            ),
          ],
        );
      },
    );
  }
}
