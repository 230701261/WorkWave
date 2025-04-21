import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../models/job_model.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/custom_snackbar.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  
  String _jobType = 'Full-time';
  String _locationType = 'Remote';
  String _budgetType = 'Fixed';
  DateTime? _deadline;
  final List<String> _selectedSkills = [];
  
  final List<String> _allSkills = [
    'Flutter', 'React', 'Angular', 'Vue.js', 'Node.js', 
    'Python', 'Java', 'Swift', 'Kotlin', 'PHP', 
    'Ruby', 'C#', 'ASP.NET', 'Django', 'Laravel',
    'SQL', 'MongoDB', 'Firebase', 'AWS', 'Azure',
    'DevOps', 'UI/UX', 'Photoshop', 'Illustrator', 'Figma'
  ];
  
  final List<String> _jobTypes = [
    'Full-time', 'Part-time', 'Contract', 'Freelance'
  ];
  
  final List<String> _locationTypes = [
    'Remote', 'On-site', 'Hybrid'
  ];
  
  final List<String> _budgetTypes = [
    'Fixed', 'Hourly'
  ];
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }
  
  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }
  
  Future<void> _postJob() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSkills.isEmpty) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select at least one skill',
          type: SnackbarType.error,
        );
        return;
      }
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      
      if (authProvider.currentUser == null) {
        CustomSnackbar.show(
          context: context,
          message: 'You must be logged in to post a job',
          type: SnackbarType.error,
        );
        return;
      }
      
      final user = authProvider.currentUser!;
      
      // Create new job
      final job = JobModel(
        clientId: user.id,
        clientName: user.name,
        clientProfileImage: user.profileImageUrl ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        skills: _selectedSkills,
        jobType: _jobType,
        locationType: _locationType,
        location: _locationController.text.trim(),
        budget: double.tryParse(_budgetController.text) ?? 0.0,
        budgetType: _budgetType,
        postedDate: DateTime.now(),
        deadline: _deadline,
        status: 'Active',
      );
      
      final success = await jobProvider.createJob(job);
      
      if (success) {
        CustomSnackbar.show(
          context: context,
          message: 'Job posted successfully',
          type: SnackbarType.success,
        );
        Get.offNamed(Routes.myJobs);
      } else {
        CustomSnackbar.show(
          context: context,
          message: jobProvider.error ?? 'Failed to post job',
          type: SnackbarType.error,
        );
      }
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
        title: Text('Post a Job'),
      ),
      body: jobProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Details',
                      style: AppThemes.subheadingStyle,
                    ),
                    const SizedBox(height: 16),
                    
                    // Job Title
                    TextFormField(
                      controller: _titleController,
                      decoration: AppThemes.inputDecoration.copyWith(
                        labelText: 'Job Title',
                        hintText: 'e.g. Flutter Developer Needed for E-commerce App',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a job title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Job Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: AppThemes.inputDecoration.copyWith(
                        labelText: 'Job Description',
                        hintText: 'Describe the job requirements, responsibilities, etc.',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a job description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Job Type
                    DropdownButtonFormField<String>(
                      decoration: AppThemes.inputDecoration.copyWith(
                        labelText: 'Job Type',
                      ),
                      value: _jobType,
                      items: _jobTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _jobType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Location Type & Location
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            decoration: AppThemes.inputDecoration.copyWith(
                              labelText: 'Location Type',
                            ),
                            value: _locationType,
                            items: _locationTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _locationType = value;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _locationController,
                            decoration: AppThemes.inputDecoration.copyWith(
                              labelText: 'Location',
                              hintText: 'e.g. New York, USA',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a location';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Budget
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _budgetController,
                            decoration: AppThemes.inputDecoration.copyWith(
                              labelText: 'Budget',
                              prefixText: '\$ ',
                              hintText: 'e.g. 500',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a budget';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            decoration: AppThemes.inputDecoration.copyWith(
                              labelText: 'Budget Type',
                            ),
                            value: _budgetType,
                            items: _budgetTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _budgetType = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Deadline
                    InkWell(
                      onTap: () => _selectDeadline(context),
                      child: InputDecorator(
                        decoration: AppThemes.inputDecoration.copyWith(
                          labelText: 'Application Deadline (Optional)',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _deadline == null
                              ? 'Select a deadline'
                              : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                          style: TextStyle(
                            color: _deadline == null
                                ? AppThemes.textSecondaryColor
                                : AppThemes.textPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Required Skills
                    Text(
                      'Required Skills',
                      style: AppThemes.subheadingStyle,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allSkills.map((skill) {
                        final isSelected = _selectedSkills.contains(skill);
                        return FilterChip(
                          label: Text(skill),
                          selected: isSelected,
                          onSelected: (_) => _toggleSkill(skill),
                          backgroundColor: Colors.grey[200],
                          selectedColor: AppThemes.primaryColor.withOpacity(0.2),
                          checkmarkColor: AppThemes.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppThemes.primaryColor
                                : AppThemes.textPrimaryColor,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _postJob,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Post Job', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 1,
        user: authProvider.currentUser!,
      ),
    );
  }
}
