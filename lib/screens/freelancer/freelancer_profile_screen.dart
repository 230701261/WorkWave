import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_item.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/streak_calendar.dart';
import '../../models/activity_streak.dart';
import '../../models/user_model.dart';

class FreelancerProfileScreen extends StatefulWidget {
  const FreelancerProfileScreen({super.key});

  @override
  _FreelancerProfileScreenState createState() =>
      _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.currentUser == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user =
        authProvider.currentUser!; // No cast needed, UserModel has all fields
    final activityStreak =
        user.activityStreak ??
        ActivityStreak(
          currentStreak: 3,
          maxStreak: 6,
          activityCalendar: {
            '2023-06-01': true,
            '2023-06-02': true,
            '2023-06-03': true,
          },
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
                    backgroundImage:
                        user.profileImageUrl != null &&
                                user.profileImageUrl!.isNotEmpty
                            ? NetworkImage(user.profileImageUrl!)
                            : null,
                    child:
                        user.profileImageUrl == null ||
                                user.profileImageUrl!.isEmpty
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
                  Text(user.name, style: AppThemes.headingStyle),
                  Text(
                    'Freelancer at ${user.location ?? 'Not Specified'}',
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Career Goals
            ProfileItem(
              title: 'Career Goals',
              description:
                  user.careerGoals ??
                  'Career goals, open to 12-15 minutes. Where do you intend to grow in career to improve in a new role?',
              onTap: () {
                Get.toNamed(Routes.editProfile);
              },
            ),

            // About
            ProfileItem(
              title: 'About',
              description:
                  user.about ??
                  'Craft an engaging story like a book and make people curious.',
              onTap: () {
                Get.toNamed(Routes.editProfile);
              },
            ),

            // Resume
            ProfileItem(
              title: 'Resume',
              description:
                  'Showcase your resume & get personalized feedback to tell who you are and what makes you unique to employers and recruiters.',
              onTap: () {
                // TODO: Implement resume upload
              },
            ),

            // Skills
            ProfileItem(
              title: 'Skills',
              description:
                  user.skills?.join(', ') ??
                  'Highlight your unique skills and watch the eye of recruiters.',
              onTap: () {
                // TODO: Implement skills editing
              },
            ),

            // Work Experience
            ProfileItem(
              title: 'Work Experience',
              description:
                  user.workExperience?.isNotEmpty ?? false
                      ? user.workExperience!.map((e) => e.title).join(', ')
                      : 'Showcase your professional journey to boost credibility.',
              onTap: () {
                // TODO: Implement work experience editing
              },
            ),

            // Education
            ProfileItem(
              title: 'Education',
              description:
                  user.education?.isNotEmpty ?? false
                      ? user.education!.map((e) => e.degree).join(', ')
                      : 'Add your educational journey & open doors to opportunities.',
              onTap: () {
                // TODO: Implement education editing
              },
            ),

            // Certificates
            ProfileItem(
              title: 'Certificates',
              description:
                  user.certificates?.isNotEmpty ?? false
                      ? user.certificates!.map((e) => e.name).join(', ')
                      : 'Add your certificates & let the world know your worth.',
              onTap: () {
                // TODO: Implement certificates editing
              },
            ),

            // Projects
            ProfileItem(
              title: 'Projects',
              description:
                  user.projects?.isNotEmpty ?? false
                      ? user.projects!.map((e) => e.name).join(', ')
                      : 'Showcase your projects to the world & prove your caliber.',
              onTap: () {
                // TODO: Implement projects editing
              },
            ),

            // Achievements
            ProfileItem(
              title: 'Achievements',
              description:
                  user.achievements?.isNotEmpty ?? false
                      ? user.achievements!.map((e) => e.title).join(', ')
                      : 'Showcase your achievements and make it remarkable.',
              onTap: () {
                // TODO: Implement achievements editing
              },
            ),

            // Social Links
            const SizedBox(height: 16),
            Text('Social Links', style: AppThemes.subheadingStyle),
            const SizedBox(height: 12),
            Row(
              children: [
                SocialLinkItem(
                  icon: Icons.work,
                  platform: 'linkedin',
                  onTap: () {
                    // TODO: Add LinkedIn
                  },
                ),
                const SizedBox(width: 12),
                SocialLinkItem(
                  icon: Icons.code,
                  platform: 'github',
                  onTap: () {
                    // TODO: Add GitHub
                  },
                ),
                const SizedBox(width: 12),
                SocialLinkItem(
                  icon: Icons.facebook,
                  platform: 'facebook',
                  onTap: () {
                    // TODO: Add Facebook
                  },
                ),
                const SizedBox(width: 12),
                SocialLinkItem(
                  icon: Icons.laptop,
                  platform: 'x',
                  onTap: () {
                    // TODO: Add Twitter/X
                  },
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    // TODO: Add more social links
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

            // Activity Streaks
            const SizedBox(height: 24),
            Text('Streaks', style: AppThemes.subheadingStyle),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: StreakCalendar(
                activityCalendar: activityStreak.activityCalendar,
                currentStreak: activityStreak.currentStreak,
                maxStreak: activityStreak.maxStreak,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 4,
        user: user, // UserModel works here
      ),
    );
  }
}
