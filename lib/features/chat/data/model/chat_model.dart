
import '../../../authentication/data/model/authentication_model.dart';
import '../../domain/entity/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.chatId,
    required super.user1,
    required super.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['_id'],
      user1: AuthenticationModel.fromJson(json['user1']),
      user2: AuthenticationModel.fromJson(json['user2']),
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': chatId,
      'user1': (user1 as AuthenticationModel).toJson(),
      'user2':(user2 as AuthenticationModel).toJson(),
    };
    
    
    return data;
  }
}
