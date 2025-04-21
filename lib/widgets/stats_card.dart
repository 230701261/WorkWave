import 'package:flutter/material.dart';
import '../app_themes.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  
  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTap,
    this.icon,
    this.backgroundColor = Colors.white,
    this.textColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                fontSize: 14,
                color: textColor ?? AppThemes.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? AppThemes.textPrimaryColor,
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: AppThemes.primaryColor,
                  ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppThemes.primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
