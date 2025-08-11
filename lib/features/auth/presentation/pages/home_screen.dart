import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_up/features/chat/domain/repositories/chat_repository.dart';
import 'package:start_up/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:start_up/features/chat/presentation/pages/chat_list_page.dart';
import '../../domain/entities/user.dart';
import '../cubit/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // --- NAVIGATION TO CHAT ---
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => ChatCubit(
                      chatRepository: context.read<ChatRepository>(),
                    )..getChatList(),
                    // Pass the current user to the ChatListPage
                    child: ChatListPage(
                      currentUser: user,
                    ), // <-- UPDATE THIS LINE
                  ),
                ),
              );
            },
          ),
          // ------------------------
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user.name}!'),
            Text('Your email is: ${user.email}'),
            const SizedBox(height: 20),
            const Text('You are now logged in.'),
          ],
        ),
      ),
    );
  }
}
