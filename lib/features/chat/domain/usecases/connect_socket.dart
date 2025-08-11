import '../repositories/chat_repository.dart';

class ConnectSocket {
  final ChatRepository repository;

  ConnectSocket(this.repository);

  Future<void> call(String token) {
    return repository.connectSocket(token);
  }
}
