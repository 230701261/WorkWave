import 'package:flutter/material.dart';
import 'dart:io';
import '../services/message_service.dart';
import '../models/message_model.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();
  
  bool _isLoading = false;
  String? _error;
  List<ChatThread> _chatThreads = [];
  List<MessageModel> _messages = [];
  ChatThread? _selectedThread;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ChatThread> get chatThreads => _chatThreads;
  List<MessageModel> get messages => _messages;
  ChatThread? get selectedThread => _selectedThread;
  
  // Fetch chat threads
  Future<void> fetchChatThreads(String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _chatThreads = await _messageService.getChatThreadsForUser(userId);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch chat threads: ${e.toString()}');
    }
  }
  
  // Fetch messages
  Future<void> fetchMessages(String userId1, String userId2) async {
    _setLoading(true);
    _clearError();
    
    try {
      _messages = await _messageService.getMessagesBetweenUsers(userId1, userId2);
      
      // Find and set selected thread
      final threadId = _getChatThreadId(userId1, userId2);
      _selectedThread = _chatThreads.firstWhere(
        (thread) => thread.id == threadId,
        orElse: () => ChatThread(
          userId1: userId1,
          userName1: 'User 1', // This would come from the user service
          userImage1: '',
          userId2: userId2,
          userName2: 'User 2', // This would come from the user service
          userImage2: '',
          lastMessageTime: DateTime.now(),
          lastMessageContent: '',
        ),
      );
      
      // Mark messages as read
      if (_selectedThread != null) {
        await _messageService.markMessagesAsRead(_selectedThread!.id, userId1);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch messages: ${e.toString()}');
    }
  }
  
  // Send message
  Future<bool> sendMessage(MessageModel message) async {
    try {
      await _messageService.sendMessage(message);
      
      // Add to messages list
      _messages.insert(0, message);
      
      // Update chat threads
      await _updateChatThreads(message.senderId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send message: ${e.toString()}');
      return false;
    }
  }
  
  // Send message with attachment
  Future<bool> sendMessageWithAttachment(MessageModel message, File file) async {
    _setLoading(true);
    _clearError();
    
    try {
      final sentMessage = await _messageService.sendMessageWithAttachment(message, file);
      
      // Add to messages list
      _messages.insert(0, sentMessage);
      
      // Update chat threads
      await _updateChatThreads(message.senderId);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send message with attachment: ${e.toString()}');
      return false;
    }
  }
  
  // Mark thread as read
  Future<void> markThreadAsRead(String threadId, String userId) async {
    try {
      await _messageService.markMessagesAsRead(threadId, userId);
      
      // Update thread in the list
      final index = _chatThreads.indexWhere((thread) => thread.id == threadId);
      if (index >= 0) {
        _chatThreads[index] = _chatThreads[index].copyWith(unreadCount: 0);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to mark thread as read: ${e.toString()}');
    }
  }
  
  // Helper methods
  Future<void> _updateChatThreads(String userId) async {
    try {
      _chatThreads = await _messageService.getChatThreadsForUser(userId);
    } catch (e) {
      print('Failed to update chat threads: ${e.toString()}');
    }
  }
  
  String _getChatThreadId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return '${userIds[0]}_${userIds[1]}';
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

extension ChatThreadExtension on ChatThread {
  ChatThread copyWith({
    String? id,
    String? userId1,
    String? userName1,
    String? userImage1,
    String? userId2,
    String? userName2,
    String? userImage2,
    DateTime? lastMessageTime,
    String? lastMessageContent,
    int? unreadCount,
  }) {
    return ChatThread(
      id: id ?? this.id,
      userId1: userId1 ?? this.userId1,
      userName1: userName1 ?? this.userName1,
      userImage1: userImage1 ?? this.userImage1,
      userId2: userId2 ?? this.userId2,
      userName2: userName2 ?? this.userName2,
      userImage2: userImage2 ?? this.userImage2,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
