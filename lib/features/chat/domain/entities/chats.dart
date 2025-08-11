class Chat {
  final String id;
  final ChatParticipant user1;
  final ChatParticipant user2;
  final String? lastMessage;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
    required this.updatedAt,
  });
}

class ChatParticipant {
  final String id;
  final String name;
  final String email;

  const ChatParticipant({
    required this.id,
    required this.name,
    required this.email,
  });
}
