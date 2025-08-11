import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/chats.dart';
import '../../domain/usecases/get_chats.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetChats getChats;

  ChatListBloc({required this.getChats}) : super(ChatListInitial()) {
    on<LoadChatsRequested>(_onLoadChats);
    on<RefreshChatsRequested>(_onLoadChats);
  }

  Future<void> _onLoadChats(
      ChatListEvent event, Emitter<ChatListState> emit) async {
    emit(ChatListLoading());
    try {
      final chats = await getChats();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(const ChatListFailure('Failed to load chats'));
    }
  }
}


