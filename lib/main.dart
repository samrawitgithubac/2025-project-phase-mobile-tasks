// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/home_screen.dart';
import 'features/auth/presentation/pages/signin_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';

// Create a GlobalKey for the navigator.
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  final client = http.Client();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: client);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
  );
  final signUpUseCase = SignUp(authRepository);
  final loginUseCase = Login(authRepository);
  final logoutUseCase = Logout(authRepository);

  runApp(
    MyApp(
      authCubit: AuthCubit(
        signUpUseCase: signUpUseCase,
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
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
          if (state is Unauthenticated) {
            _navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInPage()),
              (route) => false,
            );
          } else if (state is Authenticated) {
            _navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomeScreen(user: state.user)),
              (route) => false,
            );
          }
        },
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Ecommerce App',
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
