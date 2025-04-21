import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../app_themes.dart';
import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onTap;
  final VoidCallback? onMessageTap;
  final bool isClientView;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onMessageTap,
    this.isClientView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: AppThemes.subheadingStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppThemes.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    job.clientName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppThemes.primaryLightColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      job.locationType,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemes.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                job.location,
                style: TextStyle(
                  fontSize: 14,
                  color: AppThemes.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              if (job.budget != null)
                Text(
                  '${job.budgetType == 'Fixed' ? 'Fixed price' : 'Hourly rate'}: \$${job.budget!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppThemes.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isClientView
                        ? '${job.proposalsCount} proposals'
                        : 'Posted ${timeago.format(job.postedDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppThemes.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              
              if (onMessageTap != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onMessageTap,
                    child: Text('Message the job poster directly'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
