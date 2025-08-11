
import '../../../authentication/data/model/authentication_model.dart';
import '../../domain/entity/message.dart';
import 'chat_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.messageId,
    required super.sender,
    required super.chat,
    required super.content,
    required super.type,
  });


  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['_id'],
      sender: AuthenticationModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      content: json['content'],
      type: json['type'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': messageId,
      'sender': (sender as AuthenticationModel).toJson(),
      'chat': (chat as ChatModel).toJson(),
      'content': content,
      'type':type,
    };
    return data;
  }
}
