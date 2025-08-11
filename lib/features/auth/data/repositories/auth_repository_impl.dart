import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;
  AuthRepositoryImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected == true) {
      try {
        final user = await remoteDatasource.login(email, password);
        await localDatasource.cacheToken(user.token);
        await localDatasource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.logout();
        await localDatasource.clearToken();
        await localDatasource.clearUser();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
      String name, String email, String password) async {
    if (await networkInfo.isConnected == true) {
      try {
        final user = await remoteDatasource.signUp(name, email, password);
        await localDatasource.cacheToken(user.token);
        await localDatasource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
