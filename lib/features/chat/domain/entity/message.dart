import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entity/authentication.dart';
import 'chat.dart';

class Message extends Equatable{
  final String messageId;
  final Authentication sender;
  final Chat chat;
  final String content;
  final String type;

  const Message({
    required this.messageId,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [messageId, sender, chat, content, type];
}
