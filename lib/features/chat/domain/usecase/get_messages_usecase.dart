import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/message.dart';
import '../repository/chat_repository.dart';

class GetMessagesUsecase extends Usecase<List<Message>, Params>{
  final ChatRepository repository;

  GetMessagesUsecase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(Params params) async{
    return await repository.getMessages(params.chatId);
  }

}


class Params extends Equatable{
  final String chatId;

  const Params(this.chatId);

  @override
  List<Object?> get props => [chatId];

}