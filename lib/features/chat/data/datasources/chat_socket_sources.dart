import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../domain/entities/message.dart';
import '../models/message_model.dart';

abstract class ChatSocketDataSource {
  Future<void> connect(String token);
  Future<void> disconnect();
  Future<void> sendMessage(String chatId, String content, String type);
  Stream<Message> onMessageReceived({required String chatId});
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  static const String _baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com';

  late IO.Socket _socket;

  final _messageController = StreamController<Message>.broadcast();

  @override
  Future<void> connect(String token) async {
    _socket = IO.io(
      _baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {'Authorization': 'Bearer $token'}).build(),
    );

    _socket.on('connect', (_) {});
    _socket.on('connect_error', (data) {});

    _socket.on('message:delivered', (data) {});

    _socket.on('message:received', (data) {
      try {
        final message = MessageModel.fromJson(data);
        _messageController.add(message);
      } catch (_) {
        // Handle parsing error silently or log as needed
      }
    });
  }

  @override
  Future<void> disconnect() async {
    _socket.disconnect();
    await _messageController.close();
  }

  @override
  Future<void> sendMessage(String chatId, String content, String type) async {
    final payload = {
      'chatId': chatId,
      'content': content,
      'type': type,
    };
    _socket.emit('message:send', payload);
  }

  @override
  Stream<Message> onMessageReceived({required String chatId}) {
    return _messageController.stream.where((msg) => msg.chatId == chatId);
  }
}
