import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_up/features/auth/domain/entities/user.dart';
import 'package:start_up/features/chat/domain/entities/chat.dart';
import 'package:start_up/features/chat/presentation/cubit/chat_cubit.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;
  final User currentUser;

  const ChatDetailPage({
    Key? key,
    required this.chat,
    required this.currentUser,
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // When the page loads, tell the Cubit to fetch the message history for this specific chat.
    context.read<ChatCubit>().getMessages(widget.chat.id);
  }

  // This helper function will scroll the list to the very bottom.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController
            .position
            .minScrollExtent, // minScrollExtent is correct because the list is reversed
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine who the "other user" is in this chat for the AppBar title.
    final otherUser = widget.chat.user1.id == widget.currentUser.id
        ? widget.chat.user2
        : widget.chat.user1;

    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${otherUser.name}')),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                // Every time new messages are loaded, scroll to the bottom.
                if (state is MessagesLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                }
              },
              builder: (context, state) {
                // If the state is MessagesLoaded, build the list of messages.
                if (state is MessagesLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    controller: _scrollController,
                    reverse:
                        true, // This puts the newest messages at the bottom.
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      // Check if the message was sent by the currently logged-in user.
                      final bool isMe =
                          message.sender.id == widget.currentUser.id;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ); // <-- THIS CLOSING BRACKET WAS MISSING
                }
                // While messages are loading, show a centered spinner.
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  // This widget is the text input bar at the bottom.
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final content = _messageController.text.trim();
              if (content.isNotEmpty) {
                // When the send button is pressed, call the Cubit's sendMessage method.
                context.read<ChatCubit>().sendMessage(widget.chat.id, content);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
