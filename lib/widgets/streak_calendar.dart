import 'package:flutter/material.dart';
import '../app_themes.dart';

class StreakCalendar extends StatelessWidget {
  final Map<String, bool> activityCalendar;
  final int currentStreak;
  final int maxStreak;

  const StreakCalendar({
    Key? key,
    required this.activityCalendar,
    required this.currentStreak,
    required this.maxStreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Streak: $currentStreak days',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
              ),
            ),
            Text(
              'Max Streak: $maxStreak days',
              style: TextStyle(color: AppThemes.textSecondaryColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Simple calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 30, // Last 30 days
          itemBuilder: (context, index) {
            final date = DateTime.now().subtract(Duration(days: 29 - index));
            final dateString =
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            final isActive = activityCalendar[dateString] ?? false;

            return Container(
              decoration: BoxDecoration(
                color:
                    isActive ? AppThemes.primaryColor : AppThemes.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        ),
      ],
    );
  }
}
