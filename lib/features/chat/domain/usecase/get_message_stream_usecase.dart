import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/message.dart';
import '../repository/chat_repository.dart';

class GetMessagesStreamUsecase{
  final ChatRepository repository;

  GetMessagesStreamUsecase(this.repository);

  Stream<Either<Failure, Message>> call() {
    return  repository.getMessagesStream();
  }

}
