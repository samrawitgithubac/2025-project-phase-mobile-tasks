import '../../domain/entities/message.dart';
import 'chat_model.dart';
import 'chat_user_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required String id,
    required ChatUserModel sender,
    required String content,
    required String type,
    required ChatModel chat,
  }) : super(id: id, sender: sender, content: content, type: type, chat: chat);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      sender: ChatUserModel.fromJson(json['sender']),
      content: json['content'],
      type: json['type'],
      chat: ChatModel.fromJson(json['chat']),
    );
  }
}
