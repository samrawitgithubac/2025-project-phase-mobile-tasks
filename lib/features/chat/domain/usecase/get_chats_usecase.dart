import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/chat.dart';
import '../repository/chat_repository.dart';

class GetChatsUsecase extends Usecase<List<Chat>, NoParams>{
  final ChatRepository repository;

  GetChatsUsecase(this.repository);

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams noParams) async{
    return await repository.getChats();
  }

}
