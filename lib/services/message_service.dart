import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../models/message_model.dart';

class MessageService {
  // Mock data for messages
  final List<MessageModel> _mockMessages = [
    MessageModel(
      id: '1',
      senderId: '2', // Jane Client
      senderName: 'Jane Client',
      senderImage: '',
      receiverId: '1', // John Freelancer
      receiverName: 'John Freelancer',
      receiverImage: '',
      content: 'Hi John, I saw your profile and I\'m interested in your Flutter development skills.',
      timestamp: DateTime.now().subtract(Duration(days: 5, hours: 3)),
      isRead: true,
    ),
    MessageModel(
      id: '2',
      senderId: '1', // John Freelancer
      senderName: 'John Freelancer',
      senderImage: '',
      receiverId: '2', // Jane Client
      receiverName: 'Jane Client',
      receiverImage: '',
      content: 'Hello Jane, thank you for reaching out! I would be happy to discuss your project requirements.',
      timestamp: DateTime.now().subtract(Duration(days: 5, hours: 2, minutes: 30)),
      isRead: true,
    ),
    MessageModel(
      id: '3',
      senderId: '2', // Jane Client
      senderName: 'Jane Client',
      senderImage: '',
      receiverId: '1', // John Freelancer
      receiverName: 'John Freelancer',
      receiverImage: '',
      content: 'Great! I\'m looking to build a fitness tracking app with Flutter. Are you available for a call to discuss the details?',
      timestamp: DateTime.now().subtract(Duration(days: 5, hours: 1)),
      isRead: true,
    ),
    MessageModel(
      id: '4',
      senderId: '1', // John Freelancer
      senderName: 'John Freelancer',
      senderImage: '',
      receiverId: '2', // Jane Client
      receiverName: 'Jane Client',
      receiverImage: '',
      content: 'Yes, I\'m available. How about tomorrow at 2 PM EST?',
      timestamp: DateTime.now().subtract(Duration(days: 4, hours: 22)),
      isRead: true,
    ),
    MessageModel(
      id: '5',
      senderId: '2', // Jane Client
      senderName: 'Jane Client',
      senderImage: '',
      receiverId: '1', // John Freelancer
      receiverName: 'John Freelancer',
      receiverImage: '',
      content: 'That works for me. I\'ll send you a calendar invite with the meeting details.',
      timestamp: DateTime.now().subtract(Duration(days: 4, hours: 20)),
      isRead: true,
    ),
    MessageModel(
      id: '6',
      senderId: '2', // Jane Client
      senderName: 'Jane Client',
      senderImage: '',
      receiverId: '1', // John Freelancer
      receiverName: 'John Freelancer',
      receiverImage: '',
      content: 'I just sent you an invite. Looking forward to our call!',
      timestamp: DateTime.now().subtract(Duration(days: 4, hours: 19)),
      isRead: false,
    ),
  ];
  
  // Mock data for chat threads
  final List<ChatThread> _mockChatThreads = [
    // This will be populated on initialization
  ];
  
  // Constructor to initialize chat threads from messages
  MessageService() {
    _initializeChatThreads();
  }
  
  void _initializeChatThreads() {
    // Group messages by conversation partners
    Map<String, List<MessageModel>> conversations = {};
    
    for (var message in _mockMessages) {
      String threadId = _getChatThreadId(message.senderId, message.receiverId);
      
      if (!conversations.containsKey(threadId)) {
        conversations[threadId] = [];
      }
      
      conversations[threadId]!.add(message);
    }
    
    // Create chat threads from conversations
    for (var entry in conversations.entries) {
      String threadId = entry.key;
      List<MessageModel> messages = entry.value;
      
      // Sort messages by timestamp (descending)
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // Get latest message
      MessageModel latestMessage = messages.first;
      
      // Extract user IDs from thread ID
      List<String> userIds = threadId.split('_');
      
      // Find user details
      String userId1 = userIds[0];
      String userId2 = userIds[1];
      
      String userName1 = '';
      String userImage1 = '';
      String userName2 = '';
      String userImage2 = '';
      
      // Find user details from messages
      for (var msg in messages) {
        if (msg.senderId == userId1) {
          userName1 = msg.senderName;
          userImage1 = msg.senderImage;
        } else if (msg.receiverId == userId1) {
          userName1 = msg.receiverName;
          userImage1 = msg.receiverImage;
        }
        
        if (msg.senderId == userId2) {
          userName2 = msg.senderName;
          userImage2 = msg.senderImage;
        } else if (msg.receiverId == userId2) {
          userName2 = msg.receiverName;
          userImage2 = msg.receiverImage;
        }
      }
      
      // Count unread messages
      int unreadCount = messages.where((msg) => !msg.isRead).length;
      
      // Create chat thread
      ChatThread thread = ChatThread(
        id: threadId,
        userId1: userId1,
        userName1: userName1,
        userImage1: userImage1,
        userId2: userId2,
        userName2: userName2,
        userImage2: userImage2,
        lastMessageTime: latestMessage.timestamp,
        lastMessageContent: latestMessage.content,
        unreadCount: unreadCount,
      );
      
      _mockChatThreads.add(thread);
    }
  }

  // Create a new message
  Future<MessageModel> sendMessage(MessageModel message) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      // Add message to mock messages
      _mockMessages.add(message);
      
      // Get or create chat thread
      String threadId = _getChatThreadId(message.senderId, message.receiverId);
      
      // Check if thread exists
      int threadIndex = _mockChatThreads.indexWhere((thread) => thread.id == threadId);
      
      if (threadIndex != -1) {
        // Update existing thread
        ChatThread existingThread = _mockChatThreads[threadIndex];
        ChatThread updatedThread = ChatThread(
          id: existingThread.id,
          userId1: existingThread.userId1,
          userName1: existingThread.userName1,
          userImage1: existingThread.userImage1,
          userId2: existingThread.userId2,
          userName2: existingThread.userName2,
          userImage2: existingThread.userImage2,
          lastMessageTime: message.timestamp,
          lastMessageContent: message.content,
          unreadCount: existingThread.unreadCount + 1,
        );
        
        _mockChatThreads[threadIndex] = updatedThread;
      } else {
        // Create new thread
        ChatThread newThread = ChatThread(
          id: threadId,
          userId1: message.senderId,
          userName1: message.senderName,
          userImage1: message.senderImage,
          userId2: message.receiverId,
          userName2: message.receiverName,
          userImage2: message.receiverImage,
          lastMessageTime: message.timestamp,
          lastMessageContent: message.content,
          unreadCount: 1,
        );
        
        _mockChatThreads.add(newThread);
      }
      
      return message;
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  // Upload attachment and send message
  Future<MessageModel> sendMessageWithAttachment(
    MessageModel message,
    File file,
  ) async {
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
    
    try {
      // Simulate file upload
      String fileName = path.basename(file.path);
      String fileExtension = path.extension(fileName);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create a mock file URL (in a real app, this would be a URL from Firebase Storage)
      String fileUrl = 'https://mock-storage.example.com/${message.senderId}_$timestamp$fileExtension';
      
      // Create attachment
      MessageAttachment attachment = MessageAttachment(
        fileName: fileName,
        fileType: _getFileType(fileExtension),
        fileUrl: fileUrl,
        fileSize: await file.length(),
      );
      
      // Update message with attachment
      MessageModel messageWithAttachment = message.copyWith(attachment: attachment);
      
      // Send message
      return await sendMessage(messageWithAttachment);
    } catch (e) {
      throw Exception('Failed to send message with attachment: ${e.toString()}');
    }
  }

  // Get messages between two users
  Future<List<MessageModel>> getMessagesBetweenUsers(String userId1, String userId2) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    
    try {
      return _mockMessages
          .where((message) => 
              (message.senderId == userId1 && message.receiverId == userId2) ||
              (message.senderId == userId2 && message.receiverId == userId1))
          .toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      throw Exception('Failed to get messages: ${e.toString()}');
    }
  }

  // Get chat threads for a user
  Future<List<ChatThread>> getChatThreadsForUser(String userId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    
    try {
      return _mockChatThreads
          .where((thread) => thread.userId1 == userId || thread.userId2 == userId)
          .toList()
            ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    } catch (e) {
      throw Exception('Failed to get chat threads: ${e.toString()}');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String threadId, String userId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    
    try {
      // Extract other user ID from thread ID
      List<String> userIds = threadId.split('_');
      String otherUserId = userIds[0] == userId ? userIds[1] : userIds[0];
      
      // Update messages
      for (int i = 0; i < _mockMessages.length; i++) {
        if (_mockMessages[i].senderId == otherUserId && 
            _mockMessages[i].receiverId == userId && 
            !_mockMessages[i].isRead) {
          _mockMessages[i] = _mockMessages[i].copyWith(isRead: true);
        }
      }
      
      // Update chat thread
      int threadIndex = _mockChatThreads.indexWhere((thread) => thread.id == threadId);
      if (threadIndex != -1) {
        _mockChatThreads[threadIndex] = _mockChatThreads[threadIndex].copyWith(unreadCount: 0);
      }
    } catch (e) {
      throw Exception('Failed to mark messages as read: ${e.toString()}');
    }
  }

  // Helper method to generate chat thread ID
  String _getChatThreadId(String userId1, String userId2) {
    // Ensure consistent thread ID regardless of who is sender/receiver
    List<String> userIds = [userId1, userId2];
    userIds.sort(); // Sort to ensure same thread ID
    return '${userIds[0]}_${userIds[1]}';
  }

  // Helper method to determine file type
  String _getFileType(String fileExtension) {
    fileExtension = fileExtension.toLowerCase();
    
    if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(fileExtension)) {
      return 'image';
    } else if (['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx'].contains(fileExtension)) {
      return 'document';
    } else if (['.mp3', '.wav', '.ogg'].contains(fileExtension)) {
      return 'audio';
    } else if (['.mp4', '.mov', '.avi', '.wmv'].contains(fileExtension)) {
      return 'video';
    } else {
      return 'other';
    }
  }
}
