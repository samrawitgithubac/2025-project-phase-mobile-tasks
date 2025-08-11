import 'package:dartz/dartz.dart';
import 'package:start_up/core/error/failure.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  // For fetching historical data via REST API
  Future<Either<Failure, List<Chat>>> getChatList();
  Future<Either<Failure, List<Message>>> getMessages(String chatId);

  // For real-time actions via Socket.io
  Future<Either<Failure, void>> sendMessage(String chatId, String content);
  Stream<Message> getMessageStream(); // To listen for new messages
}
