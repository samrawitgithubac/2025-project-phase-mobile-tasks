import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entity/chat.dart';
import '../bloc/chat_bloc.dart';

import 'chat_detail_page.dart';
import '../../../product/presentation/pages/all_products_page.dart';

class ChatListPage extends StatefulWidget {
  final String token; // bearer token used to init socket
  const ChatListPage({super.key, required this.token});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial events after first frame (ensure bloc exists)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ChatBloc>();
      bloc.add(InitializeSocketEvent(widget.token));
      bloc.add(GetChatsEvent());
    });
  }

  Future<void> _refresh() async {
    context.read<ChatBloc>().add(RefreshChatsEvent());
  }

  void _openChat(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ChatBloc>(),
          child: ChatDetailPage(chat: chat),
        ),
      ),
    ).then((_) {
      // When returning from detail page, refresh list automatically.
      if (mounted) {
        context.read<ChatBloc>().add(RefreshChatsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ChatOperationFailure) {
              return _ErrorView(message: state.message, onRetry: () => context.read<ChatBloc>().add(GetChatsEvent()));
            }
            if (state is ChatsLoaded) {
              return _ChatListScaffold(
                chats: state.chats,
                onRefresh: _refresh,
                onOpenChat: _openChat,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

}

// ---- UI SUB-COMPONENTS --------------------------------------------------

class _ChatListScaffold extends StatelessWidget {
  final List<Chat> chats;
  final Future<void> Function() onRefresh;
  final void Function(Chat) onOpenChat;
  const _ChatListScaffold({required this.chats, required this.onRefresh, required this.onOpenChat});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 12),
            const _Header(),
          const SizedBox(height: 12),
          _StatusStrip(chats: chats),
          const SizedBox(height: 12),
          _ChatContainer(
            child: chats.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.0),
                    child: Center(child: Text('No chats yet')),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return _ChatRow(
                        chat: chat,
                        index: index,
                        onTap: () => onOpenChat(chat),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEF5),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Search', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF1C59D2),
            child: Text('ME', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (context) {
              // Access parent ChatListPage to fetch token via context.findAncestorStateOfType not needed; pass via InheritedWidget simpler: using ModalRoute arguments is overkill.
              // Quick approach: rely on closure capturing by using context to read ChatListPage from widget tree.
              final stateWidget = context.findAncestorStateOfType<_ChatListPageState>();
              final token = stateWidget?.widget.token;
              return IconButton(
                tooltip: 'Products',
                onPressed: token == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AllProductsPage(token: token),
                          ),
                        );
                      },
                icon: const Icon(Icons.storefront_outlined, color: Color(0xFF1C59D2)),
              );
            },
          )
        ],
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final List<Chat> chats;
  const _StatusStrip({required this.chats});

  @override
  Widget build(BuildContext context) {
    // Build a pseudo "stories" list out of distinct other users from chats.
    final others = chats.map((c) => c.user2.name ?? c.user1.name ?? 'User').toSet().toList();
    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: others.length.clamp(0, 10) + 1, // +1 for My status
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _StatusAvatar(label: 'My status', isMine: true);
          }
          final name = others[index - 1];
          return _StatusAvatar(label: _firstName(name));
        },
      ),
    );
  }

  String _firstName(String name) {
    final parts = name.split(' ');
    return parts.first.trim();
  }
}

class _StatusAvatar extends StatelessWidget {
  final String label;
  final bool isMine;
  const _StatusAvatar({required this.label, this.isMine = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isMine ? const Color(0xFF1C59D2) : _randColor(label),
                child: Text(
                  label.isNotEmpty ? label[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (isMine)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Color(0xFF1C59D2),
                      child: Icon(Icons.add, size: 14, color: Colors.white),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 60,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Color _randColor(String seed) {
    final hash = seed.codeUnits.fold<int>(0, (p, c) => p + c);
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF00B3A6),
      const Color(0xFFEA5455),
      const Color(0xFFFFA000),
      const Color(0xFF2D9CDB),
    ];
    return colors[hash % colors.length];
  }
}

class _ChatContainer extends StatelessWidget {
  final Widget child;
  const _ChatContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: child,
    );
  }
}

class _ChatRow extends StatelessWidget {
  final Chat chat;
  final int index;
  final VoidCallback onTap;
  const _ChatRow({required this.chat, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final otherName = chat.user2.name ?? chat.user1.name ?? 'User';
    final subText = _placeholderSubtitle(index);
    final time = _placeholderTime(index);
    final unread = index % 3 == 0; // pseudo unread indicator

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(name: otherName),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          subText,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1C59D2),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
                        )
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _placeholderSubtitle(int i) {
    const samples = [
      'How are you today?',
      "Don't miss to attend the meeting.",
      'Can you join the meeting?',
      'Hey! How are you today?',
      'Have a good day 🌸',
      'Are you coming?',
      'Let\'s catch up soon.',
    ];
    return samples[i % samples.length];
  }

  String _placeholderTime(int i) => '2 min ago';
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: _bg(name),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _bg(String seed) {
    final hash = seed.codeUnits.fold<int>(0, (p, c) => p + c);
    final palette = [
      const Color(0xFF00B3A6),
      const Color(0xFF1C59D2),
      const Color(0xFFEA5455),
      const Color(0xFFFFA000),
      const Color(0xFF2D9CDB),
      const Color(0xFF6C63FF),
    ];
    return palette[hash % palette.length];
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class ChatListPageWrapper extends StatelessWidget {
  final String token;
  const ChatListPageWrapper({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>(),
      child: ChatListPage(token: token),
    );
  }
}
