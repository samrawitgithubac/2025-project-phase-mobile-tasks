import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required String id,
    required MessageSenderModel sender,
    required String content,
    required String type,
    required DateTime createdAt,
    required String chatId,
  }) : super(
          id: id,
          sender: sender,
          content: content,
          type: type,
          createdAt: createdAt,
          chatId: chatId, 
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      sender: MessageSenderModel.fromJson(json['sender']),
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      chatId: json['chat']['_id']
          as String, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': (sender as MessageSenderModel).toJson(),
      'content': content,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'chat': {
        '_id': chatId,
      },
    };
  }
}

class MessageSenderModel extends MessageSender {
  const MessageSenderModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  factory MessageSenderModel.fromJson(Map<String, dynamic> json) {
    return MessageSenderModel(
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
