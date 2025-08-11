import '../../domain/entities/chats.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasources.dart';
import '../datasources/chat_remote_datasources.dart';
import '../datasources/chat_socket_sources.dart';


class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatSocketDataSource socketDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Chat>> getChats() async {

    var cachedChats = await localDataSource.getCachedChats();
    if (cachedChats.isNotEmpty) {
      return cachedChats;
    }

    var remoteChats = await remoteDataSource.getChats();

    await localDataSource.cacheChats(remoteChats);
    return remoteChats;
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {

    var cachedMessages = await localDataSource.getCachedMessages(chatId);
    if (cachedMessages.isNotEmpty) {
      return cachedMessages;
    }

    var remoteMessages = await remoteDataSource.getMessages(chatId);

    await localDataSource.cacheMessages(chatId, remoteMessages);
    return remoteMessages;
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    socketDataSource.sendMessage(chatId, content, type);
   
  }

  @override
  Stream<Message> onMessageReceived({required String chatId}) {
    final socketStream = socketDataSource.onMessageReceived(chatId: chatId);
    socketStream.listen((message) async {
      await localDataSource.cacheMessage(chatId, message);
    });

    return socketStream;
  }

  @override
  Future<void> connectSocket(String token) async {
    return socketDataSource.connect(token);
  }

  @override
  Future<void> disconnectSocket() async {
    return socketDataSource.disconnect();
  }
}
