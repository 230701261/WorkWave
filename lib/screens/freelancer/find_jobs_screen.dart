import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/job_card.dart';
import '../../widgets/custom_navbar.dart';

class FindJobsScreen extends StatefulWidget {
  const FindJobsScreen({super.key});

  @override
  _FindJobsScreenState createState() => _FindJobsScreenState();
}

class _FindJobsScreenState extends State<FindJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedJobType;
  String? _selectedLocationType;
  bool _isFilterVisible = false;
  
  @override
  void initState() {
    super.initState();
    _loadJobs();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadJobs() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    await jobProvider.fetchAllJobs();
  }
  
  void _applyFilters() {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    
    jobProvider.searchJobs(
      keyword: _searchController.text.isNotEmpty ? _searchController.text : null,
      jobType: _selectedJobType,
      locationType: _selectedLocationType,
    );
    
    setState(() {
      _isFilterVisible = false;
    });
  }
  
  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedJobType = null;
      _selectedLocationType = null;
      _isFilterVisible = false;
    });
    
    _loadJobs();
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
        title: Text('Find Jobs'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterVisible = !_isFilterVisible;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search jobs',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.sort),
                        onPressed: () {
                          // Show sort options
                        },
                      ),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                
                // Filter options (conditionally visible)
                if (_isFilterVisible) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Job Type',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          value: _selectedJobType,
                          items: [
                            'Full-time',
                            'Part-time',
                            'Contract',
                            'Freelance',
                          ].map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedJobType = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Location Type',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          value: _selectedLocationType,
                          items: [
                            'Remote',
                            'On-site',
                            'Hybrid',
                          ].map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLocationType = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          child: Text('Apply Filters'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetFilters,
                          child: Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Tab buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildTab('Preferences', isActive: false),
                const SizedBox(width: 16),
                _buildTab('My Jobs', isActive: true),
              ],
            ),
          ),
          
          // Job list
          Expanded(
            child: jobProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildJobsList(jobProvider),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 1,
        user: authProvider.currentUser!,
      ),
    );
  }
  
  Widget _buildTab(String title, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? AppThemes.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? AppThemes.primaryColor : AppThemes.textSecondaryColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildJobsList(JobProvider jobProvider) {
    if (jobProvider.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppThemes.textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No jobs found',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(
                color: AppThemes.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: jobProvider.jobs.length,
      itemBuilder: (context, index) {
        final job = jobProvider.jobs[index];
        return JobCard(
          job: job,
          onTap: () {
            // Navigate to job details
            jobProvider.fetchJobById(job.id);
            // Get.toNamed(Routes.jobDetails, arguments: job.id);
          },
          onMessageTap: () {
            // Navigate to messaging with this client
            Get.toNamed(
              Routes.chat,
              arguments: {
                'userId1': Provider.of<AuthProvider>(context, listen: false).currentUser!.id,
                'userId2': job.clientId,
              },
            );
          },
        );
      },
    );
  }
}
