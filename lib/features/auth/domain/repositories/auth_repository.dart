import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp(
      String name, String email, String password);
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}
