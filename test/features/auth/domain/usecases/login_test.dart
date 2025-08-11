import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import './sign_in_test.mocks.dart';


void main() {
  late MockAuthRepository mockAuthRepository;
  late Login login;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    login = Login(mockAuthRepository);
  });

  const String tuserName = 'test_user';
  const String temail = 'testUser@gmail.com';
  const String tpassword = 'testpassword';
  const User tUser =
      User(id: '1', name: tuserName, email: temail, token: 'test_token');
  test('Should login a user', () async {
    //arrange
    when(mockAuthRepository.login( temail, tpassword))
        .thenAnswer((_) async => const Right(tUser));
    //act
    final result = await login.call(
        const LoginParams( email: temail, password: tpassword));
    //assert
    expect(result, const Right(tUser));
    verify(mockAuthRepository.login(temail, tpassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
