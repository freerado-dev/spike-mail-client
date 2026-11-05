class EmailMessage {
  final String id;
  final String sender;
  final String avatarText;
  final String subject;
  final String snippet;
  final String time;
  final bool isUnread;
  final List<ChatMessage> chatHistory;

  EmailMessage({
    required this.id,
    required this.sender,
    required this.avatarText,
    required this.subject,
    required this.snippet,
    required this.time,
    required this.isUnread,
    required this.chatHistory,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}
