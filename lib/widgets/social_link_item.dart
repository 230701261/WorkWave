import 'package:flutter/material.dart';
import '../app_themes.dart';

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
          color: AppThemes.dividerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppThemes.textSecondaryColor,
          size: 20,
        ),
      ),
    );
  }
}