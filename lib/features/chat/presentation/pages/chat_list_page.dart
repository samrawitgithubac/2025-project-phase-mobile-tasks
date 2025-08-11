import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_up/features/auth/domain/entities/user.dart';
import 'package:start_up/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:start_up/features/chat/presentation/pages/chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  final User currentUser; // <-- ADD THIS
  const ChatListPage({Key? key, required this.currentUser})
    : super(key: key); // <-- UPDATE CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatListLoaded) {
            final chats = state.chats;
            if (chats.isEmpty) {
              return const Center(child: Text("You have no chats yet."));
            }
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                // Determine the other user in the chat
                final otherUser = chat.user1.id == currentUser.id
                    ? chat.user2
                    : chat.user1;

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(otherUser.name),
                  subtitle: const Text('Tap to view chat...'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // We provide the ChatCubit to the detail page from the same provider
                        builder: (_) => BlocProvider.value(
                          value: context.read<ChatCubit>(),
                          child: ChatDetailPage(
                            chat: chat, // <-- PASS THE ENTIRE CHAT OBJECT
                            currentUser:
                                currentUser, // <-- PASS THE CURRENT USER
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          }
          // Default to a loading indicator
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
