import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_up/features/chat/data/models/message_model.dart';
import 'package:start_up/features/chat/domain/entities/message.dart';

// This function now correctly reads the token from storage.
Future<String> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token') ?? '';
}

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket; // <-- THIS LINE WAS MISSING

  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();
  Stream<Message> get messageStream => _messageStreamController.stream;

  Future<void> connect() async {
    if (_socket?.connected ?? false) {
      print("Socket is already connected.");
      return;
    }

    final token = await getAuthToken();

    // THE FIX: Use the new base URL for the socket connection.
    const url = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': 'Bearer $token'},
    });

    // This is the single, correct onConnect handler.
    _socket!.onConnect((_) {
      print('SOCKET_SERVICE: Connected to server');

      _socket!.on('message:received', (data) {
        print('SOCKET_SERVICE: Message received: $data');
        try {
          final message = MessageModel.fromJson(data);
          _messageStreamController.add(message);
        } catch (e) {
          print("SOCKET_SERVICE: Error parsing message: $e");
        }
      });

      _socket!.on('message:delivered', (data) {
        print('SOCKET_SERVICE: Message delivered: $data');
      });
    });

    _socket!.onDisconnect(
      (_) => print('SOCKET_SERVICE: Disconnected from server'),
    );
    _socket!.onError(
      (error) => print('SOCKET_SERVICE: Connection Error: $error'),
    );
  }

  void sendMessage({required String chatId, required String content}) {
    if (_socket == null || !_socket!.connected) {
      print("Cannot send message, socket is not connected.");
      return;
    }
    final payload = {"chatId": chatId, "content": content, "type": "text"};
    _socket!.emit('message:send', payload);
    print('SOCKET_SERVICE: Sent message: $payload');
  }

  void dispose() {
    _socket?.dispose();
    _messageStreamController.close();
  }
}
