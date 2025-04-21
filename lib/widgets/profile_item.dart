import 'package:flutter/material.dart';
import '../app_themes.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const ProfileItem({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor ?? AppThemes.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color:
                    textColor != null
                        ? textColor!.withOpacity(0.7)
                        : AppThemes.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialLinkItem extends StatelessWidget {
  final IconData icon;
  final String platform;
  final VoidCallback onTap;

  const SocialLinkItem({
    super.key,
    required this.icon,
    required this.platform,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getColorForPlatform(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Color _getColorForPlatform() {
    switch (platform.toLowerCase()) {
      case 'linkedin':
        return Color(0xFF0077B5);
      case 'github':
        return Color(0xFF333333);
      case 'facebook':
        return Color(0xFF1877F2);
      case 'x':
        return Color(0xFF000000);
      default:
        return AppThemes.primaryColor;
    }
  }
}
