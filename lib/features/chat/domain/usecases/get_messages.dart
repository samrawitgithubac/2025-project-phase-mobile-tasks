import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call(String chatId) {
    return repository.getMessages(chatId);
  }
}
