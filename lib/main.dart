import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';

// Auth
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/sign_in_page.dart';
import 'features/auth/presentation/sign_up_page.dart';
import 'features/auth/presentation/splash_screen.dart';

// Chat
import 'features/chat/presentation/chat_list_page.dart';
import 'features/chat/data/datasources/chat_remote_datasources.dart';
import 'features/chat/data/datasources/chat_local_datasources.dart';
import 'features/chat/data/datasources/chat_socket_sources.dart';
import 'features/chat/data/repository/chat_repository_impl.dart';
import 'features/chat/domain/usecases/get_chats.dart';
import 'features/chat/presentation/bloc/chat_list_bloc.dart';

// Products
import 'features/products/presentation/pages/home_page.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/datasources/product_local_datasource.dart';
import 'features/products/data/repository/product_repository_impl.dart';
import 'features/products/doamin/usecases/create_new_product.dart'
    as create_product;
import 'features/products/doamin/usecases/delete_product.dart'
    as delete_product;
import 'features/products/doamin/usecases/update_product.dart'
    as update_product;
import 'features/products/doamin/usecases/view_all_products.dart' as view_all;
import 'features/products/doamin/usecases/view_specific_product.dart'
    as view_specific;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(
      networkInfo: NetworkInfoImp(InternetConnectionChecker()),
      localDatasource: AuthLocalDatasourceImp(sharedPreferences),
      remoteDatasource: AuthRemoteDatasourceImp(http.Client()),
    );

    return MultiBlocProvider(
      providers: [
        // AuthBloc
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signIn: Login(authRepository),
            signUp: SignUp(authRepository),
            logout: Logout(authRepository), 
          ),
        ),

        // ChatListBloc
        BlocProvider<ChatListBloc>(
          create: (_) {
            final token = sharedPreferences.getString('TOKEN') ?? '';
            final chatRepo = ChatRepositoryImpl(
              remoteDataSource: ChatRemoteDataSourceImpl(
                client: http.Client(),
                token: token,
              ),
              socketDataSource: ChatSocketDataSourceImpl(),
              localDataSource: ChatLocalDataSourceImpl(
                sharedPreferences: sharedPreferences,
              ),
            );
            return ChatListBloc(getChats: GetChats(chatRepo));
          },
        ),

        // ProductBloc
        BlocProvider<ProductBloc>(
          create: (_) {
            final productRepo = ProductRepositoryImpl(
              remoteDatasource: ProductRemoteDatasourceImp(http.Client()),
              localDatasource: ProductLocalDatasourceImp(sharedPreferences),
              networkInfo: NetworkInfoImp(InternetConnectionChecker()),
            );

            return ProductBloc(
              viewAllProducts: view_all.ViewAllProductsUsecase(productRepo),
              viewProduct: view_specific.ViewProductUsecase(productRepo),
              createProduct: create_product.CreateProductUsecase(productRepo),
              updateProduct: update_product.UpdateProductUsecase(productRepo),
              deleteProduct: delete_product.DeleteProductUsecase(productRepo),
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        initialRoute: '/',
        routes: {
          '/': (_) => SplashScreen(),
          '/signup': (_) => SignUpPage(),
          '/signin': (_) => SignInPage(),
          '/chats': (_) => const ChatPage(),
          '/products': (_) => const HomePage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
