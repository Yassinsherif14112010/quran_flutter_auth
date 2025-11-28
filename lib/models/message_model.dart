class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'type': type.toString(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'] ?? '',
      receiverId: json['receiverId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] == 1,
      type: _parseMessageType(json['type']),
    );
  }

  static MessageType _parseMessageType(String type) {
    if (type.contains('audio')) return MessageType.audio;
    if (type.contains('image')) return MessageType.image;
    return MessageType.text;
  }
}

enum MessageType {
  text,
  audio,
  image,
}

class Chat {
  final String id;
  final String userId1;
  final String userId2;
  final String user1Name;
  final String user2Name;
  final String user1Avatar;
  final String user2Avatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.user1Name,
    required this.user2Name,
    required this.user1Avatar,
    required this.user2Avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.messages = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId1': userId1,
      'userId2': userId2,
      'user1Name': user1Name,
      'user2Name': user2Name,
      'user1Avatar': user1Avatar,
      'user2Avatar': user2Avatar,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId1: json['userId1'],
      userId2: json['userId2'],
      user1Name: json['user1Name'],
      user2Name: json['user2Name'],
      user1Avatar: json['user1Avatar'] ?? '',
      user2Avatar: json['user2Avatar'] ?? '',
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
