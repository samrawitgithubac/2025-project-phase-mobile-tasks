import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/chat.dart';
import '../repository/chat_repository.dart';

class GetChatByIdUsecase extends Usecase<Chat, Params> {
  final ChatRepository repository;

  GetChatByIdUsecase(this.repository);

  @override
  Future<Either<Failure, Chat>> call(Params params) async {
    return await repository.getChatById(params.chatId);
  }
}

class Params extends Equatable {
  final String chatId;

  const Params(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
