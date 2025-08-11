import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart'; // <-- CORRECT IMPORT
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(String name, String email, String password);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

// THE DUPLICATE CLASS THAT WAS HERE HAS BEEN REMOVED

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = "https://api.escuelajs.co/api/v1";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://picsum.photos/800',
      }),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final loginResponse = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (loginResponse.statusCode == 201) {
      final accessToken = json.decode(loginResponse.body)['access_token'];
      final profileResponse = await client.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (profileResponse.statusCode == 200) {
        return UserModel.fromJson(json.decode(profileResponse.body));
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    return Future.value();
  }
}
