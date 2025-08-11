import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/chat.dart';
import '../entity/message.dart';

abstract class ChatRepository{
  // --- REST API Methods (for initial data and management) ---

  /// Fetches the list of all chats for the current user.
  Future<Either<Failure, List<Chat>>> getChats();

  /// Fetches a single chat by its ID.
  Future<Either<Failure, Chat>> getChatById(String chatId);

  /// Fetches the historical messages for a specific chat.
  Future<Either<Failure, List<Message>>> getMessages(String chatId);

  /// Creates a new chat with a given user.
  Future<Either<Failure, Chat>> initiateChat(String userId);

  /// Deletes a chat by its ID.
  Future<Either<Failure, void>> deleteChat(String chatId);

  // --- WebSocket Methods (for real-time communication) ---


  /// Sends a new message to a specific chat via the socket.
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String content,
  });

  /// Listens for incoming messages in real-time from the socket.
  /// Corresponds to: socket.on('message:received', ...)
  Stream<Either<Failure, Message>> getMessagesStream();
}