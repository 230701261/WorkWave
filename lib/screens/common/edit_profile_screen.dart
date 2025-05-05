import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../app_themes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();
  final _careerGoalsController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _profileImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    _careerGoalsController.dispose();
    super.dispose();
  }

  void _initializeUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _locationController.text = user.location ?? '';
      _aboutController.text = user.about ?? '';
      _careerGoalsController.text = user.careerGoals ?? '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.currentUser;

        if (user == null) {
          throw Exception('User not found');
        }

        // In a real app, we would upload the image and update the user profile
        // through proper API calls using a UserService

        // For this demo, we'll just show a success message
        await Future.delayed(Duration(seconds: 1)); // Simulate network delay

        CustomSnackbar.show(
          context: context,
          message: 'Profile updated successfully',
          type: SnackbarType.success,
        );

        Get.back();
      } catch (e) {
        CustomSnackbar.show(
          context: context,
          message: 'Failed to update profile: ${e.toString()}',
          type: SnackbarType.error,
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isFreelancer = user.userType == 'freelancer';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _saveProfile,
            child: _isUploading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (user.profileImageUrl != null &&
                                  user.profileImageUrl!.isNotEmpty
                              ? NetworkImage(user.profileImageUrl!)
                                  as ImageProvider<Object>
                              : null),
                      child: _profileImage == null &&
                              (user.profileImageUrl == null ||
                                  user.profileImageUrl!.isEmpty)
                          ? Text(
                              user.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppThemes.primaryColor,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppThemes.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                          onPressed: _pickImage,
                          constraints: BoxConstraints.tightFor(
                            width: 36,
                            height: 36,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Basic Info
              Text(
                'Basic Information',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: AppThemes.inputDecoration.copyWith(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email (disabled)
              TextFormField(
                controller: _emailController,
                decoration: AppThemes.inputDecoration.copyWith(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  helperText: 'Email cannot be changed',
                ),
                readOnly: true,
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: AppThemes.inputDecoration.copyWith(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'e.g. New York, USA',
                ),
              ),
              const SizedBox(height: 24),

              // Profile Details
              Text(
                'Profile Details',
                style: AppThemes.subheadingStyle,
              ),
              const SizedBox(height: 16),

              // About
              TextFormField(
                controller: _aboutController,
                decoration: AppThemes.inputDecoration.copyWith(
                  labelText: 'About',
                  prefixIcon: Icon(Icons.info_outline),
                  hintText: isFreelancer
                      ? 'Tell clients about yourself and your expertise'
                      : 'Tell freelancers about your company',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Career Goals (only for freelancers)
              if (isFreelancer) ...[
                TextFormField(
                  controller: _careerGoalsController,
                  decoration: AppThemes.inputDecoration.copyWith(
                    labelText: 'Career Goals',
                    prefixIcon: Icon(Icons.trending_up),
                    hintText: 'Where do you want to grow in your career?',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
              ],

              // Additional Profile Sections
              _buildProfileSection(
                title: 'Skills',
                description:
                    'Add your skills to attract relevant job opportunities',
                icon: Icons.psychology_outlined,
                onTap: () {
                  // Navigate to skills editor
                },
              ),

              if (isFreelancer) ...[
                _buildProfileSection(
                  title: 'Work Experience',
                  description:
                      'Add your professional experience to boost your profile',
                  icon: Icons.work_outline,
                  onTap: () {
                    // Navigate to work experience editor
                  },
                ),
                _buildProfileSection(
                  title: 'Education',
                  description: 'Add your educational background',
                  icon: Icons.school_outlined,
                  onTap: () {
                    // Navigate to education editor
                  },
                ),
                _buildProfileSection(
                  title: 'Certifications',
                  description: 'Add your professional certifications',
                  icon: Icons.card_membership_outlined,
                  onTap: () {
                    // Navigate to certifications editor
                  },
                ),
              ] else ...[
                _buildProfileSection(
                  title: 'Company Details',
                  description: 'Add information about your company',
                  icon: Icons.business_outlined,
                  onTap: () {
                    // Navigate to company details editor
                  },
                ),
                _buildProfileSection(
                  title: 'Industry',
                  description: 'Specify your company\'s industry',
                  icon: Icons.category_outlined,
                  onTap: () {
                    // Navigate to industry selection
                  },
                ),
              ],

              _buildProfileSection(
                title: 'Social Links',
                description: 'Connect your professional social profiles',
                icon: Icons.link,
                onTap: () {
                  // Navigate to social links editor
                },
              ),

              const SizedBox(height: 24),

              // Delete Account
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteAccountConfirmation();
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppThemes.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // In a real app, we would call an API to delete the user account
                CustomSnackbar.show(
                  context: context,
                  message: 'Account deletion is not implemented in this demo',
                  type: SnackbarType.info,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }
}
