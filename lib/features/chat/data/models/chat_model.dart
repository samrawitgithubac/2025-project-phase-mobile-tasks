import '../../domain/entities/chats.dart';

class ChatModel extends Chat {
  const ChatModel({
    required String id,
    required ChatParticipantModel user1,
    required ChatParticipantModel user2,
    String? lastMessage,
    required DateTime updatedAt,
  }) : super(
          id: id,
          user1: user1,
          user2: user2,
          lastMessage: lastMessage,
          updatedAt: updatedAt,
        );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] as String,
      user1: ChatParticipantModel.fromJson(json['user1']),
      user2: ChatParticipantModel.fromJson(json['user2']),
      lastMessage: json['lastMessage'] as String?,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': (user1 as ChatParticipantModel).toJson(),
      'user2': (user2 as ChatParticipantModel).toJson(),
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ChatParticipantModel extends ChatParticipant {
  const ChatParticipantModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
