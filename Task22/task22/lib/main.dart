import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'features/auth/data/datasources/remote_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
void main() {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://g5-flutter-learning-path-be.onrender.com/api/v2'),
  ); // Example local API

  final remoteDataSource = RemoteAuthDataSource(dio);
  final secureStorage = FlutterSecureStorage();
  final authRepo = AuthRepositoryImpl(remoteDataSource, secureStorage);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepo),
            signUpUseCase: SignUpUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
            secureStorage: secureStorage,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const SplashPage(), // Or LoginPage() if you prefer
    );
  }
}
