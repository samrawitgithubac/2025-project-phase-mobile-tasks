import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start_up/features/chat/domain/entities/chat.dart';
import 'package:start_up/features/chat/domain/entities/message.dart';
import 'package:start_up/features/chat/domain/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<Message>? _messageSubscription;

  ChatCubit({required this.chatRepository}) : super(ChatInitial()) {
    _listenToMessages();
  }

  void _listenToMessages() {
    _messageSubscription = chatRepository.getMessageStream().listen((
      newMessage,
    ) {
      if (state is MessagesLoaded) {
        final currentMessages = (state as MessagesLoaded).messages;
        emit(MessagesLoaded([newMessage, ...currentMessages]));
      }
    });
  }

  Future<void> getChatList() async {
    emit(ChatLoading());
    final failureOrChats = await chatRepository.getChatList();
    failureOrChats.fold(
      (failure) => emit(const ChatError('Failed to load chats.')),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

  Future<void> getMessages(String chatId) async {
    emit(ChatLoading());
    final failureOrMessages = await chatRepository.getMessages(chatId);
    failureOrMessages.fold(
      (failure) => emit(const ChatError('Failed to load messages.')),
      (messages) => emit(MessagesLoaded(messages)),
    );
  }

  Future<void> sendMessage(String chatId, String content) async {
    await chatRepository.sendMessage(chatId, content);
    // The message will be added to the state via the stream listener.
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
