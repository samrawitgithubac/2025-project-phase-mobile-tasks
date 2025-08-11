import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/auth_model.dart';

abstract class AuthLocalDatasource {
  Future<String> getToken();
  Future<void> clearToken();
  Future<void> cacheToken(String token);
  Future<AuthModel> getUser(); 
  Future<void> cacheUser(AuthModel authModel);
  Future<void> clearUser();
}

class AuthLocalDatasourceImp implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;
  AuthLocalDatasourceImp(this.sharedPreferences);

  @override
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString('TOKEN', token);
  }

  @override
  Future<void> cacheUser(AuthModel authModel) {
    final userJson = jsonEncode(authModel.toJson());
    return sharedPreferences.setString('USER', userJson);
  }

  @override
  Future<void> clearToken() async {
    final success = await sharedPreferences.remove('TOKEN');
    if (!success) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearUser() async {
    final success = await sharedPreferences.remove('USER');
    if (!success) {
      throw CacheException();
    }
  }


  @override
  Future<String> getToken() async {
    final token = sharedPreferences.getString('TOKEN');
    if (token != null) {
      return token;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<AuthModel> getUser() async {
    final user = sharedPreferences.getString('USER');
    if (user != null) {
      return AuthModel.fromJson(jsonDecode(user));
    } else {
      throw CacheException();
    }
  }
}
