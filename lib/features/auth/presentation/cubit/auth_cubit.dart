import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUp signUpUseCase;
  final Login loginUseCase;
  final Logout logoutUseCase;

  AuthCubit({
    required this.signUpUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial());

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    print("CUBIT_DEBUG: Attempting to sign up for email: $email");

    try {
      final failureOrUser = await signUpUseCase(
        SignUpParams(name: name, email: email, password: password),
      );

      failureOrUser.fold(
        (failure) {
          print("CUBIT_DEBUG: Signup FAILED. Failure: $failure");
          emit(
            const AuthError('Signup Failed. Please check the API response.'),
          );
        },
        (user) {
          print("CUBIT_DEBUG: Signup SUCCEEDED. User: ${user.name}");
          emit(Authenticated(user));
        },
      );
    } catch (error, stackTrace) {
      print("CUBIT_DEBUG: An UNEXPECTED ERROR occurred during signup.");
      print("CUBIT_DEBUG: ERROR: $error");
      print("CUBIT_DEBUG: STACK TRACE: $stackTrace");
      emit(AuthError('An unexpected error occurred: $error'));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final failureOrUser = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    failureOrUser.fold(
      (failure) => emit(const AuthError('Login Failed')),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final failureOrVoid = await logoutUseCase(NoParams());
    failureOrVoid.fold(
      (failure) => emit(const AuthError('Logout Failed')),
      (_) => emit(Unauthenticated()),
    );
  }

  // In lib/features/auth/presentation/cubit/auth_cubit.dart

  void checkAuthStatus() async {
    // Make the function async
    print("DEBUG: 1. checkAuthStatus() has been CALLED.");

    // THIS IS THE FIX: Wait for the current frame to build before emitting a state.
    await Future.delayed(Duration.zero);

    print("DEBUG: 2. Emitting Unauthenticated state NOW.");
    emit(Unauthenticated());
  }
}
