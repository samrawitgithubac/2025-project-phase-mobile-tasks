import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../../domain/entities/chats.dart';
import '../../domain/entities/message.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';


abstract class ChatRemoteDataSource {
  Future<List<Chat>> getChats();
  Future<Chat> getChatById(String chatId);
  Future<List<Message>> getMessages(String chatId);
  Future<Chat> initiateChat(Map<String, dynamic> body);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String token;

  static const String baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com';

  ChatRemoteDataSourceImpl({
    required this.client,
    required this.token,
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<Chat>> getChats() async {
    final url = Uri.parse('$baseUrl/api/v3/chats');
    final response = await client.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Chat> getChatById(String chatId) async {
    final url = Uri.parse('$baseUrl/api/v3/chats/$chatId');
    final response = await client.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return ChatModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/api/v3/chats/$chatId/messages');
    final response = await client.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Chat> initiateChat(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/v3/chats');
    final response =
        await client.post(url, headers: _headers, body: json.encode(body));

    if (response.statusCode == 201) {
      return ChatModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
