import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';

class RemoteAuthDataSource {
  final Dio dio;

  RemoteAuthDataSource(this.dio);

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  Future<AuthResponseModel> signUp(
    String name,
    String email,
    String password,
  ) async {
    final response = await dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response.data);
  }
}
