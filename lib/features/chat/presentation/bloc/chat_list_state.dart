part of 'chat_list_bloc.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<Chat> chats;
  const ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatListFailure extends ChatListState {
  final String message;
  const ChatListFailure(this.message);

  @override
  List<Object?> get props => [message];
}


