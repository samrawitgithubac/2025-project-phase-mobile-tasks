import 'package:equatable/equatable.dart';
import 'chat_user.dart';

class Chat extends Equatable {
  final String id;
  final ChatUser user1;
  final ChatUser user2;

  const Chat({required this.id, required this.user1, required this.user2});

  @override
  List<Object> get props => [id, user1, user2];
}
