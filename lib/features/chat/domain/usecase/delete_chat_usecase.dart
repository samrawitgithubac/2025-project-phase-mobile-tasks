import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/chat_repository.dart';

class DeleteChatUsecase extends Usecase<void, Params>{
  final ChatRepository repository;

  DeleteChatUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async{
    return await repository.deleteChat(params.chatId);
  }

}


class Params extends Equatable{
  final String chatId;

  const Params(this.chatId);

  @override
  List<Object?> get props => [chatId];

}