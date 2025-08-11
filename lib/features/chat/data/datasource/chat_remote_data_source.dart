import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/error/exceptions.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';

abstract class ChatRemoteDataSource {

  /// Initializes the socket connection. Must be called after login.
  Future<void> initSocket(String token);

  /// Fetches the list of all chats for the current user;
  Future<List<ChatModel>> getChats();

  /// Fetches a single chat by its ID.
  Future<ChatModel> getChatById(String chatId);

  /// Fetches the historical messages for a specific chat.
  Future<List<MessageModel>> getMessages(String chatId);

  /// Creates a new chat with a given user.
  Future<ChatModel> initiateChat(String userId);

  /// Deletes a chat by its ID.
  Future<void> deleteChat(String chatId);

  // --- WebSocket Methods (for real-time communication) ---


  /// Sends a new message to a specific chat via the socket.
  void sendMessage({
    required String chatId,
    required String content,
  });

  /// Listens for incoming messages in real-time from the socket.
  /// Corresponds to: socket.on('message:received', ...)
  Stream<MessageModel> getMessagesStream();

  void disposeSocket();
  
}


class ChatRemoteDataSourceImpl implements ChatRemoteDataSource{
  final http.Client client;
  late IO.Socket socket;
  String? _token;
  final _messageStreamController = StreamController<MessageModel>.broadcast();

  static const BASE_URL = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  ChatRemoteDataSourceImpl({required this.client});

  

  @override
  Future<void> initSocket(String token) async {
    _token = token;
    try {
      socket = IO.io(BASE_URL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'extraHeaders': {'Authorization': 'Bearer $token'}
      });

      socket.connect();

      socket.onConnect((_) {
        print('Socket connected');
      });

      socket.onDisconnect((_) => print('Socket disconnected'));
      socket.onConnectError((err) => print('Socket connection error: $err'));
      socket.onError((err) => print('Socket error: $err'));

      socket.on('message:received', (data) {
        if (kDebugMode) {
          try { print('[Socket] message:received chatId=' + (data['chat']['_id'] ?? data['chatId']).toString() + ' content=' + data['content'].toString()); } catch (_) {}
        }
        _messageStreamController.add(MessageModel.fromJson(data));
    });

    socket.on('message:delivered', (data) {
        _messageStreamController.add(MessageModel.fromJson(data));
      });
    } catch (e) {
      throw SocketException(e.toString());
    }
  }


  @override
  void disposeSocket() {
    _messageStreamController.close();
    socket.dispose();
  }



  Future<T> _performRequest<T>(
    Future<http.Response> Function(Map<String, String> headers) request, {
    required int successStatusCode,
    required T Function(dynamic data) fromJson,
  }) async {
    if (_token == null) throw const SocketException('Token not available.');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await request(headers);
      if (response.statusCode == successStatusCode) {
        if (response.body.isEmpty) {
          return fromJson(null);
        }
        final jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          final preview = response.body.length > 300
              ? response.body.substring(0, 300) + '...'
              : response.body;
          print('[ChatRemoteDataSource][_performRequest] status=$successStatusCode bodyPreview=$preview');
          if (jsonResponse is Map && !jsonResponse.containsKey('data')) {
            print('[ChatRemoteDataSource][_performRequest] WARNING: response has no top-level "data" key. Keys=${jsonResponse.keys}');
          }
        }
        // This assumes all successful responses have their data in a 'data' key.
        return fromJson(jsonResponse['data']);
      } else {
        throw ServerException();
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
  
  @override
  Future<void> deleteChat(String chatId) {
    return _performRequest(
      (headers) => client.delete(
        Uri.parse('$BASE_URL/api/v3/chats/$chatId'),
        headers: headers,
      ),
      successStatusCode: 200,
      fromJson: (_) => {},
    );
  }

  @override
  Future<ChatModel> getChatById(String chatId) {
    return _performRequest(
      (headers) => client.get(
        Uri.parse('$BASE_URL/api/v3/chats/$chatId'),
        headers: headers,
      ),
      successStatusCode: 200,
      fromJson: (data) => ChatModel.fromJson(data),
    );
  }

  @override
  Future<List<ChatModel>> getChats() {
    return _performRequest(
      (headers) => client.get(
        Uri.parse('$BASE_URL/api/v3/chats'),
        headers: headers,
      ),
      successStatusCode: 200,
      fromJson: (data) => (data as List)
          .map((chatJson) => ChatModel.fromJson(chatJson))
          .toList(),
    );
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) {
    if (kDebugMode) {
      print('[ChatRemoteDataSource] Fetching messages for chatId=$chatId');
    }
    return _performRequest(
      (headers) => client.get(
        Uri.parse('$BASE_URL/api/v3/chats/$chatId/messages'),
        headers: headers,
      ),
      successStatusCode: 200,
      fromJson: (data) {
        // Backend may return either a raw list OR an object containing a 'messages' list.
        dynamic rawList;
        if (kDebugMode) {
          print('[ChatRemoteDataSource] Raw data type: ${data.runtimeType}');
          if (data is Map) {
            print('[ChatRemoteDataSource] Top-level keys: ${data.keys.toList()}');
          }
        }
        if (data is List) {
          rawList = data;
        } else if (data is Map && data['messages'] is List) {
          rawList = data['messages'];
        } else if (data is Map && data['data'] is List) { // extra safety
          rawList = data['data'];
        } else if (data is Map && data['messages'] is Map && data['messages']['docs'] is List) {
          rawList = data['messages']['docs'];
        } else if (data is Map && data['chat'] is Map && (data['chat']['messages'] is List)) {
          rawList = data['chat']['messages'];
        } else if (data is Map && data['chat'] is Map && data['chat']['messages'] is Map && data['chat']['messages']['docs'] is List) {
          rawList = data['chat']['messages']['docs'];
        } else {
          rawList = <dynamic>[]; // fallback empty
        }
        final list = (rawList as List)
            .whereType<dynamic>()
            .map((msgJson) => MessageModel.fromJson((msgJson as Map).cast<String, dynamic>()))
            .toList();
        if (kDebugMode) {
          print('[ChatRemoteDataSource] Parsed messages count=${list.length} for chatId=$chatId');
          if (list.isEmpty && data is Map) {
            // Show a snippet of the structure to help debugging
            final snippet = data.toString();
            print('[ChatRemoteDataSource] Empty after parsing. Data snippet: ${snippet.substring(0, snippet.length.clamp(0, 300))}');
          }
        }
        return list;
      },
    ).then((messages) {
      if (kDebugMode) {
        for (final m in messages.take(3)) {
          print('[ChatRemoteDataSource] Sample message: id=${m.messageId} content=${m.content}');
        }
      }
      return messages;
    });
  }

  @override
  Stream<MessageModel> getMessagesStream() {
    return _messageStreamController.stream;
  }

  @override
  Future<ChatModel> initiateChat(String userId) {
    return _performRequest(
      (headers) => client.post(
        Uri.parse('$BASE_URL/api/v3/chats'),
        headers: headers,
        body: jsonEncode({'userId': userId})
      ),
      successStatusCode: 201,
      fromJson: (data) => ChatModel.fromJson(data),
    );
  }

  @override
  void sendMessage({required String chatId, required String content}) {
   if (kDebugMode) {
     print('[Socket] message:send chatId=$chatId content=$content');
   }
   socket.emit('message:send', {
      'chatId': chatId,
      'content': content,
      'type': 'text',
    });
  }
    
}