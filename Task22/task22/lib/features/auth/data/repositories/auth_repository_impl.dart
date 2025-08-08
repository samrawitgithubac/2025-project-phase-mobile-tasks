import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<User> login(String email, String password) async {
    final authResponse = await remoteDataSource.login(email, password);
    await secureStorage.write(key: 'token', value: authResponse.token);
    return authResponse.user;
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    final authResponse = await remoteDataSource.signUp(name, email, password);
    await secureStorage.write(key: 'token', value: authResponse.token);
    return authResponse.user;
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: 'token');
  }
}
