import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/entities/user.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login signIn;
  final SignUp signUp;
  final Logout logout;

  AuthBloc({required this.signIn, required this.signUp, required this.logout}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await signIn(
          LoginParams(email: event.email, password: event.password));
      result.fold(
        (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
        (user) => emit(AuthSuccess(user)),
      );
    } on SocketException {
      emit(const AuthFailure(
          'No internet connection. Please check your network.'));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUp(SignUpParams(name: event.name, email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logout(const NoParams());
    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (_) => emit(AuthInitial()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
