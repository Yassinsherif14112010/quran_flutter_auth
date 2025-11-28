import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final UserModel currentUser;
  final UserModel otherUser;

  const ChatScreen({
    Key? key,
    required this.currentUser,
    required this.otherUser,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // رسائل وهمية للاختبار
    _messages.addAll([
      Message(
        id: '1',
        senderId: widget.otherUser.id,
        senderName: widget.otherUser.name,
        senderAvatar: '',
        receiverId: widget.currentUser.id,
        content: 'السلام عليكم ورحمة الله وبركاته',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
      ),
      Message(
        id: '2',
        senderId: widget.otherUser.id,
        senderName: widget.otherUser.name,
        senderAvatar: '',
        receiverId: widget.currentUser.id,
        content: 'كيف حالك؟ هل تريد جلسة تسميع الآن؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        type: MessageType.text,
      ),
      Message(
        id: '3',
        senderId: widget.currentUser.id,
        senderName: widget.currentUser.name,
        senderAvatar: '',
        receiverId: widget.otherUser.id,
        content: 'وعليكم السلام ورحمة الله وبركاته',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        type: MessageType.text,
      ),
      Message(
        id: '4',
        senderId: widget.currentUser.id,
        senderName: widget.currentUser.name,
        senderAvatar: '',
        receiverId: widget.otherUser.id,
        content: 'نعم، أريد أن أسمع سورة البقرة',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        type: MessageType.text,
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.currentUser.id,
      senderName: widget.currentUser.name,
      senderAvatar: '',
      receiverId: widget.otherUser.id,
      content: _messageController.text,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // تمرير لأسفل
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // رد وهمي من المحفظ
    Future.delayed(const Duration(seconds: 2), () {
      final reply = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: widget.otherUser.id,
        senderName: widget.otherUser.name,
        senderAvatar: '',
        receiverId: widget.currentUser.id,
        content: 'حسناً، استعد للتسميع. ابدأ من الآية الأولى',
        timestamp: DateTime.now(),
        type: MessageType.text,
      );

      if (mounted) {
        setState(() {
          _messages.add(reply);
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUser.name),
            const SizedBox(height: 4),
            Text(
              'متاح الآن',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[300],
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة المكالمات قريباً')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة مكالمات الفيديو قريباً')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // قائمة الرسائل
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser =
                    message.senderId == widget.currentUser.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isCurrentUser ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // حقل الإدخال
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // زر الملفات
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('سيتم إضافة إرسال الملفات قريباً'),
                      ),
                    );
                  },
                ),

                // حقل الرسالة
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),

                const SizedBox(width: 8),

                // زر الصوت
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('سيتم إضافة الرسائل الصوتية قريباً'),
                      ),
                    );
                  },
                ),

                // زر الإرسال
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
