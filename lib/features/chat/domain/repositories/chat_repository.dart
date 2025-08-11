import '../entities/chats.dart';
import '../entities/message.dart';



abstract class ChatRepository {

  Future<List<Chat>> getChats();


  Future<List<Message>> getMessages(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });

  Stream<Message> onMessageReceived({required String chatId});
  Future<void> connectSocket(String token);
  Future<void> disconnectSocket();
}

