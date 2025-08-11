import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String token; 

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  @override
  List<Object> get props => [id, name, email, token];
}
