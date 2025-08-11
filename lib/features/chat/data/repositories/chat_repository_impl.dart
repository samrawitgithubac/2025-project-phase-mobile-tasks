import 'package:dartz/dartz.dart';
import 'package:start_up/core/error/exceptions.dart';
import 'package:start_up/core/error/failure.dart';
import 'package:start_up/core/services/socket_service.dart';
import 'package:start_up/features/chat/domain/entities/chat.dart';
import 'package:start_up/features/chat/domain/entities/message.dart';
import 'package:start_up/features/chat/domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final SocketService socketService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketService,
  });

  @override
  Future<Either<Failure, List<Chat>>> getChatList() async {
    try {
      final result = await remoteDataSource.getChatList();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    try {
      final result = await remoteDataSource.getMessages(chatId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
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
      return Left(ServerFailure());
    }
  }
}
