import 'package:equatable/equatable.dart';
import 'chat.dart';
import 'chat_user.dart';

class Message extends Equatable {
  final String id;
  final ChatUser sender;
  final String content;
  final String type;
  final Chat chat;

  const Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.type,
    required this.chat,
  });

  @override
  List<Object> get props => [id, sender, content, type, chat];
}
