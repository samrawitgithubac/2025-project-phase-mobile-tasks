import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entity/authentication.dart';

class Chat extends Equatable {
  final String chatId;
  final Authentication user1;
  final Authentication user2;

  const Chat({
    required this.chatId, 
    required this.user1, 
    required this.user2
  });

  @override
  List<Object?> get props => [chatId, user1, user2];
}
