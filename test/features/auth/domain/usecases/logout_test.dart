import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/logout.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import './sign_in_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late Logout logout;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logout = Logout(mockAuthRepository);
  });

  
  test('Should logout a user', () async {
    //arrange
    when(mockAuthRepository.logout())
        .thenAnswer((_) async => const Right(null));
    //act
    final result =
       await logout.call(const NoParams());

    //assert
    expect(result, const Right(null));
    verify(mockAuthRepository.logout());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
