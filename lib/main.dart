import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:start_up/features/chat/data/datasources/chat_remote_data_source.dart';

// Auth Imports
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/home_screen.dart';
import 'features/auth/presentation/pages/signin_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';

// Chat Imports
import 'core/services/socket_service.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';

// Create a GlobalKey for the navigator.
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // === DEPENDENCY INJECTION SETUP ===

  // --- Auth Dependencies ---
  final client = http.Client();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: client);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
  );
  final signUpUseCase = SignUp(authRepository);
  final loginUseCase = Login(authRepository);
  final logoutUseCase = Logout(authRepository);

  // --- Chat Dependencies ---
  // Create a single instance of the SocketService
  final socketService = SocketService();
  final chatRemoteDataSource = ChatRemoteDataSourceImpl(client: client);
  // Create the ChatRepository implementation, giving it the socket service
  final chatRepository = ChatRepositoryImpl(
    socketService: socketService,
    remoteDataSource: chatRemoteDataSource, // <-- PASS IT HERE
  );

  runApp(
    // We can use RepositoryProvider to make the chat repository available
    // to any widgets that need it later on.
    RepositoryProvider<ChatRepository>(
      create: (context) => chatRepository,
      child: MyApp(
        authCubit: AuthCubit(
          signUpUseCase: signUpUseCase,
          loginUseCase: loginUseCase,
          logoutUseCase: logoutUseCase,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  const MyApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => authCubit..checkAuthStatus(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Point 2: Initialize Socket is handled here
          if (state is Authenticated) {
            print("MAIN: User is Authenticated. Connecting to socket...");
            // Connect to the socket service now that we are logged in.
            SocketService().connect();

            _navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomeScreen(user: state.user)),
              (route) => false,
            );
          } else if (state is Unauthenticated) {
            _navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInPage()),
              (route) => false,
            );
          }
        },
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Ecommerce App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
