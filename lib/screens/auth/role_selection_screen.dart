import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join WorkWave'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'How would you like to use WorkWave?',
                  style: AppThemes.headingStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Freelancer Option
                _buildRoleCard(
                  title: 'Join as a Freelancer',
                  description:
                      'Find work, submit proposals, and earn money working on projects that match your skills.',
                  icon: Icons.work_outline,
                  onTap: () {
                    Get.toNamed(Routes.register, arguments: 'freelancer');
                  },
                ),

                const SizedBox(height: 24),

                // Client Option
                _buildRoleCard(
                  title: 'Join as a Client',
                  description:
                      'Post jobs, hire talented professionals, and get your projects completed.',
                  icon: Icons.business_center_outlined,
                  onTap: () {
                    Get.toNamed(Routes.register, arguments: 'client');
                  },
                ),

                const SizedBox(height: 40),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(Routes.login);
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppThemes.primaryColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: AppThemes.primaryColor,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: AppThemes.subheadingStyle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: AppThemes.bodyStyle.copyWith(
                  color: AppThemes.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: AppThemes.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
