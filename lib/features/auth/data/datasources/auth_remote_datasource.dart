import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> signUp(String name, String email, String password);
  Future<AuthModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDatasourceImp implements AuthRemoteDatasource {
  final http.Client httpClient;
  final String baseUrl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2";
      

  AuthRemoteDatasourceImp(this.httpClient);

  @override
  Future<AuthModel> login(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final accessToken = jsonResponse['data']['access_token'];

      // Optionally store the token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', accessToken);

      // Decode JWT to extract user info if needed
      Map<String, dynamic> decodedToken = {};
      try {
        decodedToken = JwtDecoder.decode(accessToken);
      } catch (_) {}

      return AuthModel(
        id: decodedToken['sub']?.toString() ?? '',
        name: decodedToken['name'] ?? '',
        email: decodedToken['email'] ?? email,
        token: accessToken,
      );
    } else {
      print('Login failed: ${response.statusCode} - ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<AuthModel> signUp(String name, String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      // The register endpoint returns full user info in data
      return AuthModel.fromJson(jsonResponse);
    } else {
      print('Sign up failed: ${response.statusCode} - ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    return Future.value();
  }
}
