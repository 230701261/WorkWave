import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_themes.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppThemes.primaryColor.withOpacity(0.2),
              backgroundImage: message.senderImage.isNotEmpty
                  ? NetworkImage(message.senderImage)
                  : null,
              child: message.senderImage.isEmpty
                  ? Text(
                      message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: AppThemes.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCurrentUser ? AppThemes.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
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
                  // Display the content
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : AppThemes.textPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  
                  // Display the time
                  SizedBox(height: 4),
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp),
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white.withOpacity(0.8) : AppThemes.textSecondaryColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          
          if (isCurrentUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppThemes.primaryColor.withOpacity(0.2),
              backgroundImage: message.senderImage.isNotEmpty
                  ? NetworkImage(message.senderImage)
                  : null,
              child: message.senderImage.isEmpty
                  ? Text(
                      message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: AppThemes.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}