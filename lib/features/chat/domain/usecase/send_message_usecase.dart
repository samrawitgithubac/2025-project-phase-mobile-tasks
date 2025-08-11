import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/chat_repository.dart';

class SendMessageUsecase extends Usecase<void, Params> {
  final ChatRepository repository;

  SendMessageUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.sendMessage(chatId: params.chatId, content: params.content);
  }
}

class Params extends Equatable {
  final String chatId;
  final String content;

  const Params({
    required this.chatId, 
    required this.content
  });

  @override
  List<Object?> get props => [chatId, content];
}
