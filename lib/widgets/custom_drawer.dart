import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../app_themes.dart';
import '../routes.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class CustomDrawer extends StatelessWidget {
  final UserModel user;
  
  const CustomDrawer({
    super.key,
    required this.user,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isFreelancer = user.userType == 'freelancer';
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header with user info
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppThemes.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFreelancer ? 'Freelancer Dashboard' : 'Client Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (isFreelancer) ...[
                  _buildDrawerItem(
                    title: 'Earnings',
                    icon: Icons.attach_money,
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.earnings);
                    },
                    showTrailing: false,
                    textColor: Colors.white,
                  ),
                  _buildDrawerItem(
                    title: 'Industry Analysis',
                    icon: Icons.analytics_outlined,
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.industryAnalysis);
                    },
                    showTrailing: false,
                    textColor: Colors.white,
                  ),
                ] else ...[
                  _buildDrawerItem(
                    title: 'Payments',
                    icon: Icons.payment_outlined,
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.payments);
                    },
                    showTrailing: false,
                    textColor: Colors.white,
                  ),
                  _buildDrawerItem(
                    title: 'Market Analysis',
                    icon: Icons.analytics_outlined,
                    onTap: () {
                      Get.back();
                      // Navigate to market analysis for clients
                    },
                    showTrailing: false,
                    textColor: Colors.white,
                  ),
                ],
              ],
            ),
          ),
          
          // Main navigation items
          const SizedBox(height: 8),
          
          // Logout button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false).logout();
                Get.offAllNamed(Routes.login);
              },
              icon: Icon(Icons.logout, color: AppThemes.textSecondaryColor),
              label: Text(
                'Logout',
                style: TextStyle(color: AppThemes.textSecondaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppThemes.dividerColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool showTrailing = true,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppThemes.textPrimaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppThemes.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showTrailing ? Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }
}
