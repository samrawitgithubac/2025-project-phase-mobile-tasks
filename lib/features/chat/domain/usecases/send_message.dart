import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call({
    required String chatId,
    required String content,
    required String type,
  }) {
    return repository.sendMessage(
      chatId: chatId,
      content: content,
      type: type,
    );
  }
}
