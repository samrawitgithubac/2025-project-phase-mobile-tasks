import 'package:dartz/dartz.dart';
import 'package:start_up/core/error/failure.dart';
import 'package:start_up/core/services/socket_service.dart'; // Import the service
import 'package:start_up/features/chat/domain/entities/chat.dart';
import 'package:start_up/features/chat/domain/entities/message.dart';
import 'package:start_up/features/chat/domain/repositories/chat_repository.dart';

// You would also create a ChatRemoteDataSource for HTTP requests
// import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  // final ChatRemoteDataSource remoteDataSource; // For HTTP
  final SocketService socketService; // For real-time

  ChatRepositoryImpl({
    /*required this.remoteDataSource,*/ required this.socketService,
  });

  @override
  Future<Either<Failure, List<Chat>>> getChatList() async {
    // TODO: Implement HTTP call to fetch chat list from the API v3 endpoint
    // final result = await remoteDataSource.getChatList();
    // For now, return an empty list
    return Right([]);
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    // TODO: Implement HTTP call to fetch message history
    // final result = await remoteDataSource.getMessages(chatId);
    return Right([]);
  }

  @override
  Stream<Message> getMessageStream() {
    return socketService.messageStream;
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    String chatId,
    String content,
  ) async {
    try {
      socketService.sendMessage(chatId: chatId, content: content);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure()); // Or a more specific socket failure
    }
  }
}
