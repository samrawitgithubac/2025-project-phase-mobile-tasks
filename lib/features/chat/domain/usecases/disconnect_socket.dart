import '../repositories/chat_repository.dart';

class DisconnectSocket {
  final ChatRepository repository;

  DisconnectSocket(this.repository);

  Future<void> call() {
    return repository.disconnectSocket();
  }
}
