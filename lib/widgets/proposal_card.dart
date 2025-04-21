import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../app_themes.dart';
import '../models/proposal_model.dart';

class ProposalCard extends StatelessWidget {
  final ProposalModel proposal;
  final VoidCallback? onTap;
  final bool isClientView;

  const ProposalCard({
    super.key,
    required this.proposal,
    this.onTap,
    this.isClientView = false,
  });

  Color _getStatusColor() {
    switch (proposal.status) {
      case 'Pending':
        return Colors.amber;
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = isClientView ? proposal.freelancerName : proposal.clientName;
    final image = isClientView ? proposal.freelancerProfileImage : '';
    
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
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
                    backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                    child: image.isEmpty
                        ? Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: AppThemes.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isClientView ? name : proposal.jobTitle,
                          style: AppThemes.subheadingStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isClientView ? proposal.jobTitle : name,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppThemes.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      proposal.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bid Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemes.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '\$${proposal.bidAmount.toStringAsFixed(2)} ${proposal.bidType}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemes.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '${proposal.estimatedDuration} ${proposal.bidType == 'Fixed' ? 'days' : 'hours'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submitted',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemes.textSecondaryColor,
                        ),
                      ),
                      Text(
                        timeago.format(proposal.submittedDate),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
