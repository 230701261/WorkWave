import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../app_themes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../models/message_model.dart';
import '../../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isAttachmentOptionsVisible = false;
  
  late String _userId1;
  late String _userId2;
  String _userName1 = '';
  String _userName2 = '';
  final String _userImage1 = '';
  final String _userImage2 = '';
  
  @override
  void initState() {
    super.initState();
    
    // Get user IDs from arguments
    final args = Get.arguments as Map<String, dynamic>;
    _userId1 = args['userId1'];
    _userId2 = args['userId2'];
    
    _loadMessages();
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMessages() async {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    
    // For a real app, we would fetch user details from a user service
    // For now, we'll use placeholders
    _userName1 = 'Current User';
    _userName2 = 'Other User';
    
    await messageProvider.fetchMessages(_userId1, _userId2);
  }
  
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    
    final message = MessageModel(
      senderId: _userId1,
      senderName: _userName1,
      senderImage: _userImage1,
      receiverId: _userId2,
      receiverName: _userName2,
      receiverImage: _userImage2,
      content: text,
      timestamp: DateTime.now(),
    );
    
    final success = await messageProvider.sendMessage(message);
    
    if (success) {
      _messageController.clear();
      _scrollToBottom();
    }
  }
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile == null) return;
      
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      
      final message = MessageModel(
        senderId: _userId1,
        senderName: _userName1,
        senderImage: _userImage1,
        receiverId: _userId2,
        receiverName: _userName2,
        receiverImage: _userImage2,
        content: 'Sent an image',
        timestamp: DateTime.now(),
      );
      
      final success = await messageProvider.sendMessageWithAttachment(
        message,
        File(pickedFile.path),
      );
      
      if (success) {
        _scrollToBottom();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    
    // Hide attachment options
    setState(() {
      _isAttachmentOptionsVisible = false;
    });
  }
  
  void _pickDocument() async {
    // Hide attachment options
    setState(() {
      _isAttachmentOptionsVisible = false;
    });
    
    // Show a snackbar indicating document picking is not implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Document picking is not implemented in this demo'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    final currentUser = authProvider.currentUser;
    final messages = messageProvider.messages;
    
    // Get the other user's name for the app bar
    String otherUserName = 'Chat';
    if (messageProvider.selectedThread != null) {
      otherUserName = _userId1 == messageProvider.selectedThread!.userId1
          ? messageProvider.selectedThread!.userName2
          : messageProvider.selectedThread!.userName1;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Implement call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messageProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet. Start the conversation!',
                          style: TextStyle(color: AppThemes.textSecondaryColor),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isCurrentUser = message.senderId == _userId1;
                          return ChatBubble(
                            message: message,
                            isCurrentUser: isCurrentUser,
                          );
                        },
                      ),
          ),
          
          // Attachment options
          if (_isAttachmentOptionsVisible)
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.image,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    onTap: _pickDocument,
                  ),
                ],
              ),
            ),
          
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    setState(() {
                      _isAttachmentOptionsVisible = !_isAttachmentOptionsVisible;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppThemes.primaryColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppThemes.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppThemes.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppThemes.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
