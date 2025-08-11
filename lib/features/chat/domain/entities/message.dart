class Message {
  final String id;
  final MessageSender sender;
  final String content;
  final String type;
  final DateTime createdAt;
  final String chatId; // Added chatId field

  const Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.chatId, // include in constructor
  });
}

class MessageSender {
  final String id;
  final String name;
  final String email;

  const MessageSender({
    required this.id,
    required this.name,
    required this.email,
  });
}
