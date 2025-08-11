import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './sign_in_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUp signUp;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUp = SignUp(mockAuthRepository);
  });

  const String tuserName = 'test_user';
  const String temail = 'testUser@gmail.com';
  const String tpassword = 'testpassword';
  const User tUser =
      User(id: '1', name: tuserName, email: temail, token: 'test_token');
  test('Should signup a user', () async {
    //arrange
    when(mockAuthRepository.signUp(tuserName, temail, tpassword))
        .thenAnswer((_) async => const Right(tUser));
    //act
    final result = await signUp
        .call(const SignUpParams(name: tuserName, email: temail, password: tpassword));
    //assert
    expect(result, const Right(tUser));
    verify(mockAuthRepository.signUp(tuserName, temail, tpassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
