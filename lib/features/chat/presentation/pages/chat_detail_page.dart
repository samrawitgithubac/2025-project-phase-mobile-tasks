import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/chat.dart';
import '../../domain/entity/message.dart';
import '../bloc/chat_bloc.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;
  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<Message> _pending = []; // optimistic local

  Color get _outgoingColor => const Color(0xFF4B4FFD);
  Color get _incomingColor => const Color(0xFFEAF1FF);
  Color get _bgColor => const Color(0xFFF8F9FB);

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetMessagesEvent(widget.chat.chatId));
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final temp = Message(
      messageId: 'tmp-${DateTime.now().microsecondsSinceEpoch}',
      sender: widget.chat.user1, // TODO: replace with actual logged-in user
      chat: widget.chat,
      content: text,
      type: 'text',
    );
    setState(() => _pending.add(temp));
    context.read<ChatBloc>().add(SendMessageEvent(chatId: widget.chat.chatId, content: text));
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _Header(chat: widget.chat),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listenWhen: (p, c) => c is MessagesLoaded,
              listener: (_, state) {
                if (state is MessagesLoaded) _scrollToBottom();
              },
              builder: (context, state) {
                if (state is MessagesLoading && state.chatId == widget.chat.chatId) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatOperationFailure) {
                  return Center(child: Text(state.message));
                }
                List<Message> messages = [];
                if (state is MessagesLoaded && state.chatId == widget.chat.chatId) {
                  messages = state.messages;
                }
                // Merge optimistic
                final displayed = [
                  ...messages,
                  ..._pending.where((p) => !messages.any((m) => m.content == p.content && m.sender.id == p.sender.id)),
                ];
                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: displayed.length,
                  itemBuilder: (context, index) {
                    final m = displayed[index];
                    final previous = index > 0 ? displayed[index - 1] : null;
                    final isFirstOfGroup = previous == null || previous.sender.id != m.sender.id;
                    final isMe = m.sender.id == widget.chat.user1.id;
                    return _MessageBubble(
                      message: m,
                      isMe: isMe,
                      isFirstOfGroup: isFirstOfGroup,
                      outgoingColor: _outgoingColor,
                      incomingColor: _incomingColor,
                      showAvatar: isFirstOfGroup && !isMe,
                      userInitial: (m.sender.name ?? 'U').isNotEmpty ? m.sender.name![0].toUpperCase() : 'U',
                    );
                  },
                );
              },
            ),
          ),
          _InputBar(
            controller: _controller,
            onSend: _send,
            primaryColor: _outgoingColor,
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Chat chat;
  const _Header({required this.chat});
  @override
  Widget build(BuildContext context) {
    final name = chat.user2.name ?? 'Chat';
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEDD4FF),
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
          ),
          const SizedBox(width: 12),
            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                const Text('2 members, 1 online', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isFirstOfGroup;
  final bool showAvatar;
  final Color outgoingColor;
  final Color incomingColor;
  final String userInitial;
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.isFirstOfGroup,
    required this.showAvatar,
    required this.outgoingColor,
    required this.incomingColor,
    required this.userInitial,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = _buildBubble();
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: isMe ? 60 : 8, right: isMe ? 8 : 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            if (showAvatar)
              CircleAvatar(radius: 16, child: Text(userInitial))
            else
              const SizedBox(width: 32),
            const SizedBox(width: 8),
            Flexible(child: bubble),
          ] else ...[
            Flexible(child: bubble),
            const SizedBox(width: 8),
            if (showAvatar)
              const CircleAvatar(radius: 16, child: Text('You'))
            else
              const SizedBox(width: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildBubble() {
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 18),
    );

    Widget content;
    switch (message.type) {
      case 'image':
        content = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.content,
            width: 220,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 220,
              height: 140,
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image),
            ),
          ),
        );
        break;
      case 'audio':
        content =const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: Colors.white),
            SizedBox(width: 4),
            Text('00:16', style: TextStyle(color: Colors.white)),
          ],
        );
        break;
      default:
        content = Text(
          message.content,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        );
    }

    final bubbleColor = isMe ? outgoingColor : incomingColor;
    return Container(
      padding: message.type == 'image' ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: message.type == 'image' ? Colors.transparent : bubbleColor,
        borderRadius: radius,
      ),
      child: content,
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final Color primaryColor;
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, -2),
              color: Color(0x11000000),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: 'Write your message',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
