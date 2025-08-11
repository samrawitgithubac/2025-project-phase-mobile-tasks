import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class OnMessageReceived {
  final ChatRepository repository;

  OnMessageReceived(this.repository);

  Stream<Message> call({required String chatId}) {
    return repository.onMessageReceived(chatId: chatId);
  }
}
