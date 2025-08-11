import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/chat.dart';
import '../repository/chat_repository.dart';

class InitiateChatUsecase extends Usecase<Chat, Params> {
  final ChatRepository repository;

  InitiateChatUsecase(this.repository);

  @override
  Future<Either<Failure, Chat>> call(Params params) async {
    return await repository.initiateChat(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params(this.userId);

  @override
  List<Object?> get props => [userId];
}
