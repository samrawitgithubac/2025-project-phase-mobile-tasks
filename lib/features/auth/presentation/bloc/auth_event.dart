part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const SignUpRequested({required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
