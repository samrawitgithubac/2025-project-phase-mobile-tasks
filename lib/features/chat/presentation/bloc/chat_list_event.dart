part of 'chat_list_bloc.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatsRequested extends ChatListEvent {
  const LoadChatsRequested();
}

class RefreshChatsRequested extends ChatListEvent {
  const RefreshChatsRequested();
}
