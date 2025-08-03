import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class Usecase<Type,Params> {
  Future<Either<Failure,Type>> call (Params params);
}
class NoParams{}