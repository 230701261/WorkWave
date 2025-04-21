import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../app_themes.dart';
import '../models/message_model.dart';

class MessageCard extends StatelessWidget {
  final ChatThread thread;
  final String currentUserId;
  final VoidCallback onTap;

  const MessageCard({
    super.key,
    required this.thread,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if user is user1 or user2 in the thread
    final isUser1 = currentUserId == thread.userId1;
    
    // Get other user's details
    final otherUserName = isUser1 ? thread.userName2 : thread.userName1;
    final otherUserImage = isUser1 ? thread.userImage2 : thread.userImage1;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Profile image
            CircleAvatar(
              radius: 24,
              backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
              backgroundImage: otherUserImage.isNotEmpty ? NetworkImage(otherUserImage) : null,
              child: otherUserImage.isEmpty
                  ? Text(
                      otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: AppThemes.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        otherUserName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeago.format(thread.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemes.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.lastMessageContent,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: thread.unreadCount > 0
                                ? AppThemes.textPrimaryColor
                                : AppThemes.textSecondaryColor,
                            fontWeight: thread.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (thread.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppThemes.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            thread.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppThemes.primaryColor
              : AppThemes.primaryLightColor,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: isCurrentUser ? Radius.circular(16) : Radius.circular(0),
            bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : AppThemes.textPrimaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeago.format(message.timestamp),
              style: TextStyle(
                color: isCurrentUser
                    ? Colors.white.withOpacity(0.7)
                    : AppThemes.textSecondaryColor,
                fontSize: 12,
              ),
            ),
            
            // Attachment preview if exists
            if (message.attachment != null) ...[
              const SizedBox(height: 8),
              _buildAttachmentPreview(message.attachment!),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildAttachmentPreview(MessageAttachment attachment) {
    Widget preview;
    
    switch (attachment.fileType) {
      case 'image':
        preview = Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(attachment.fileUrl),
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
      
      default:
        preview = Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getFileIcon(attachment.fileType),
                color: isCurrentUser ? Colors.white : AppThemes.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  attachment.fileName,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : AppThemes.textPrimaryColor,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
    }
    
    return GestureDetector(
      onTap: () {
        // TODO: Open attachment
      },
      child: preview,
    );
  }
  
  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'document':
        return Icons.insert_drive_file;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.attach_file;
    }
  }
}
