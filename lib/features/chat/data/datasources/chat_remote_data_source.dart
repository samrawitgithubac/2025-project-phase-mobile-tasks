import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_up/core/error/exceptions.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChatList();
  Future<List<MessageModel>> getMessages(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  // THE FIX: Point to the new, working V2 API.
  final String baseUrl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3";

  ChatRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ChatModel>> getChatList() async {
    // THE FIX: Use the V2 chats endpoint.
    final response = await client.get(
      Uri.parse('$baseUrl/chats'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> jsonList = responseBody['data'];
      return jsonList.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    // THE FIX: Use the V2 messages endpoint.
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> jsonList = responseBody['data'];
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
