import 'dart:convert';
import 'package:http/http.dart' as http; // THIS IS CORRECT
import 'package:jwt_decoder/jwt_decoder.dart'; // <-- ADD THIS IMPORT
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(String name, String email, String password);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 201) {
      // The register endpoint returns the full user, so we can use that.
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      final accessToken = responseBody['data']['access_token'];

      // --- THE FIX: DECODE THE TOKEN ---
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', accessToken);

      // Create a UserModel from the token's data.
      // We use the email as a fallback for the name, since the name is not in the token.
      return UserModel.fromJson({
        '_id': decodedToken['sub'], // The user ID is in the 'sub' field
        'email': decodedToken['email'],
        'name': decodedToken['email'], // Using email as name fallback
      });
      // ---------------------------------
    } else {
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
