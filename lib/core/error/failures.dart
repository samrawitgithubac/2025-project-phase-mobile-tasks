import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object> get props => [];

  String get message;
}

class ServerFailure extends Failure {
  @override
  String get message => 'Server error occurred';
}

class CacheFailure extends Failure {
  @override
  String get message => 'Cache error occurred';
}
