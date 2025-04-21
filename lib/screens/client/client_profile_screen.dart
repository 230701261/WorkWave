import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_item.dart';
import '../../widgets/custom_navbar.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.currentUser == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final user = authProvider.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
                    backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
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
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: AppThemes.headingStyle,
                  ),
                  Text(
                    'Client at ${user.location ?? 'Not Specified'}',
                    style: TextStyle(
                      color: AppThemes.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.editProfile);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About
            ProfileItem(
              title: 'About',
              description: user.about ??
                  'Tell us about your company or organization to attract the best talent.',
              onTap: () {
                Get.toNamed(Routes.editProfile);
              },
            ),
            
            // Company Details
            ProfileItem(
              title: 'Company Details',
              description: 'Add information about your company to help freelancers understand your business better.',
              onTap: () {
                // Navigate to edit company details
              },
            ),
            
            // Industry
            ProfileItem(
              title: 'Industry',
              description: 'Specify your industry to help match with relevant freelancers.',
              onTap: () {
                // Navigate to industry selection
              },
            ),
            
            // Payment Methods
            ProfileItem(
              title: 'Payment Methods',
              description: 'Manage your payment methods to ensure smooth transactions with freelancers.',
              onTap: () {
                Get.toNamed(Routes.payments);
              },
            ),
            
            // Social Links
            const SizedBox(height: 16),
            Text(
              'Social Links',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SocialLinkItem(
                  icon: Icons.language,
                  platform: 'website',
                  onTap: () {
                    // Add website
                  },
                ),
                const SizedBox(width: 12),
                SocialLinkItem(
                  icon: Icons.work,
                  platform: 'linkedin',
                  onTap: () {
                    // Add LinkedIn
                  },
                ),
                const SizedBox(width: 12),
                SocialLinkItem(
                  icon: Icons.facebook,
                  platform: 'facebook',
                  onTap: () {
                    // Add Facebook
                  },
                ),
                const SizedBox(width: 12),
                SocialLinkItem(
                  icon: Icons.laptop,
                  platform: 'x',
                  onTap: () {
                    // Add Twitter/X
                  },
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    // Add more social links
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppThemes.dividerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppThemes.textSecondaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            
            // Hiring History
            const SizedBox(height: 24),
            Text(
              'Hiring History',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 48,
                      color: AppThemes.textSecondaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hiring history yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start hiring freelancers to build your team.',
                      style: TextStyle(
                        color: AppThemes.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Get.toNamed(Routes.postJob);
                      },
                      child: Text('Post a Job'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 4,
        user: user,
      ),
    );
  }
}
