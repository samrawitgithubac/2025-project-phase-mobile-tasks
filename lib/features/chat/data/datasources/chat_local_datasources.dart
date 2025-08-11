import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/chats.dart';
import '../../domain/entities/message.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<Chat>> getCachedChats();
  Future<void> cacheChats(List<Chat> chats);

  Future<List<Message>> getCachedMessages(String chatId);
  Future<void> cacheMessages(String chatId, List<Message> messages);
  Future<void> cacheMessage(String chatId, Message message);
 
}



class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String chatsKey = 'CACHED_CHATS';
  static const String messagesKeyPrefix = 'CACHED_MESSAGES_';

  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Chat>> getCachedChats() async {
    final jsonString = sharedPreferences.getString(chatsKey);
    if (jsonString == null) return [];

    final List<dynamic> decodedList = json.decode(jsonString);
    return decodedList.map((chatJson) => ChatModel.fromJson(chatJson)).toList();
  }

  @override
  Future<void> cacheChats(List<Chat> chats) async {
    final List<Map<String, dynamic>> jsonList =
        chats.map((chat) => (chat as ChatModel).toJson()).toList();

    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(chatsKey, jsonString);
  }

  @override
  Future<List<Message>> getCachedMessages(String chatId) async {
    final jsonString = sharedPreferences.getString(messagesKeyPrefix + chatId);
    if (jsonString == null) return [];

    final List<dynamic> decodedList = json.decode(jsonString);
    return decodedList.map((msgJson) => MessageModel.fromJson(msgJson)).toList();
  }

  @override
  Future<void> cacheMessages(String chatId, List<Message> messages) async {
    final List<Map<String, dynamic>> jsonList =
        messages.map((msg) => (msg as MessageModel).toJson()).toList();

    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(messagesKeyPrefix + chatId, jsonString);
  }

  @override
  Future<void> cacheMessage(String chatId, Message message) async {
    final key = messagesKeyPrefix + chatId;
    final jsonString = sharedPreferences.getString(key);

    List<dynamic> decodedList = [];
    if (jsonString != null) {
      decodedList = json.decode(jsonString);
    }

    decodedList.add((message as MessageModel).toJson());
    final updatedJsonString = json.encode(decodedList);
    await sharedPreferences.setString(key, updatedJsonString);
  }

}
