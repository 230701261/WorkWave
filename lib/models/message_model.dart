import 'package:uuid/uuid.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderImage;
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final MessageAttachment? attachment;

  MessageModel({
    String? id,
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.attachment,
  }) : id = id ?? Uuid().v4();

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      receiverImage: json['receiverImage'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      attachment: json['attachment'] != null
          ? MessageAttachment.fromJson(json['attachment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['senderId'] = senderId;
    data['senderName'] = senderName;
    data['senderImage'] = senderImage;
    data['receiverId'] = receiverId;
    data['receiverName'] = receiverName;
    data['receiverImage'] = receiverImage;
    data['content'] = content;
    data['timestamp'] = timestamp.toIso8601String();
    data['isRead'] = isRead;
    if (attachment != null) data['attachment'] = attachment!.toJson();
    return data;
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderImage,
    String? receiverId,
    String? receiverName,
    String? receiverImage,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    MessageAttachment? attachment,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverImage: receiverImage ?? this.receiverImage,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      attachment: attachment ?? this.attachment,
    );
  }
}

class MessageAttachment {
  final String id;
  final String fileName;
  final String fileType;
  final String fileUrl;
  final int fileSize; // In bytes

  MessageAttachment({
    String? id,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    required this.fileSize,
  }) : id = id ?? Uuid().v4();

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'],
      fileName: json['fileName'],
      fileType: json['fileType'],
      fileUrl: json['fileUrl'],
      fileSize: json['fileSize'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fileName'] = fileName;
    data['fileType'] = fileType;
    data['fileUrl'] = fileUrl;
    data['fileSize'] = fileSize;
    return data;
  }
}

class ChatThread {
  final String id;
  final String userId1;
  final String userName1;
  final String userImage1;
  final String userId2;
  final String userName2;
  final String userImage2;
  final DateTime lastMessageTime;
  final String lastMessageContent;
  final int unreadCount;

  ChatThread({
    String? id,
    required this.userId1,
    required this.userName1,
    required this.userImage1,
    required this.userId2,
    required this.userName2,
    required this.userImage2,
    required this.lastMessageTime,
    required this.lastMessageContent,
    this.unreadCount = 0,
  }) : id = id ?? Uuid().v4();

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['id'],
      userId1: json['userId1'],
      userName1: json['userName1'],
      userImage1: json['userImage1'],
      userId2: json['userId2'],
      userName2: json['userName2'],
      userImage2: json['userImage2'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessageContent: json['lastMessageContent'],
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId1'] = userId1;
    data['userName1'] = userName1;
    data['userImage1'] = userImage1;
    data['userId2'] = userId2;
    data['userName2'] = userName2;
    data['userImage2'] = userImage2;
    data['lastMessageTime'] = lastMessageTime.toIso8601String();
    data['lastMessageContent'] = lastMessageContent;
    data['unreadCount'] = unreadCount;
    return data;
  }

  // Added copyWith method
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