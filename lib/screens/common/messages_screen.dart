import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../app_themes.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../widgets/message_card.dart';
import '../../widgets/custom_navbar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMessages();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMessages() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      await messageProvider.fetchChatThreads(authProvider.currentUser!.id);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final messageProvider = Provider.of<MessageProvider>(context);
    
    if (authProvider.currentUser == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final user = authProvider.currentUser!;
    
    // Filter chat threads based on search query
    final filteredThreads = _searchQuery.isEmpty
        ? messageProvider.chatThreads
        : messageProvider.chatThreads.where((thread) {
            final otherUserName = thread.userId1 == user.id
                ? thread.userName2
                : thread.userName1;
            return otherUserName.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(96),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search messages',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // Show more options
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppThemes.primaryColor,
                unselectedLabelColor: AppThemes.textSecondaryColor,
                indicatorColor: AppThemes.primaryColor,
                tabs: [
                  Tab(text: 'Messages'),
                  Tab(text: 'Jobs'),
                  Tab(text: 'Unread'),
                  Tab(text: 'Draft'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Messages Tab
          RefreshIndicator(
            onRefresh: _loadMessages,
            child: messageProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildMessagesList(filteredThreads, user.id),
          ),
          
          // Jobs Tab
          Center(child: Text('Jobs related messages will appear here')),
          
          // Unread Tab
          Center(child: Text('Unread messages will appear here')),
          
          // Draft Tab
          Center(child: Text('Draft messages will appear here')),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 3,
        user: user,
      ),
    );
  }
  
  Widget _buildMessagesList(List<dynamic> threads, String userId) {
    if (threads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppThemes.textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: AppThemes.subheadingStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation with freelancers or clients',
              style: TextStyle(
                color: AppThemes.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      itemCount: threads.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 76,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final thread = threads[index];
        return MessageCard(
          thread: thread,
          currentUserId: userId,
          onTap: () {
            // Navigate to chat screen
            final otherUserId = thread.userId1 == userId ? thread.userId2 : thread.userId1;
            
            Get.toNamed(
              Routes.chat,
              arguments: {
                'userId1': userId,
                'userId2': otherUserId,
              },
            );
          },
        );
      },
    );
  }
}
