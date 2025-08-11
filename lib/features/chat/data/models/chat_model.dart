import 'package:start_up/features/chat/domain/entities/chat.dart';
import 'chat_user_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required String id,
    required ChatUserModel user1,
    required ChatUserModel user2,
  }) : super(id: id, user1: user1, user2: user2);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      user1: ChatUserModel.fromJson(json['user1']),
      user2: ChatUserModel.fromJson(json['user2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': (user1 as ChatUserModel).toJson(),
      'user2': (user2 as ChatUserModel).toJson(),
    };
  }
}
