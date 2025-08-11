import 'package:dartz/dartz.dart';

import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecommerce_app/features/auth/data/models/auth_model.dart';
import 'package:ecommerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthLocalDatasource, AuthRemoteDatasource, NetworkInfo])
void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthLocalDatasource localDatasource;
  late MockAuthRemoteDatasource remoteDatasource;
  late AuthRepositoryImpl repositoryImpl;
  setUp(() {
    remoteDatasource = MockAuthRemoteDatasource();
    localDatasource = MockAuthLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = AuthRepositoryImpl(
        localDatasource: localDatasource,
        remoteDatasource: remoteDatasource,
        networkInfo: mockNetworkInfo);
  });

  const String tuserName = 'test_user';
  const String temail = 'testUser@gmail.com';
  const String tpassword = 'testpassword';
  const AuthModel tUser =
      AuthModel(id: '1', name: tuserName, email: temail, token: 'test_token');
  group('device online tests', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('Should Signup a user', () async {
      //arrange
      when(remoteDatasource.signUp(tuserName, temail, tpassword))
          .thenAnswer((_) async => tUser);
      //act
      final result = await repositoryImpl.signUp(tuserName, temail, tpassword);
      //assert
      expect(result, const Right(tUser));

      verify(remoteDatasource.signUp(tuserName, temail, tpassword));
      verify(localDatasource.cacheToken(tUser.token));
      verify(localDatasource.cacheUser(tUser));
      verifyNoMoreInteractions(localDatasource);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Should login a user', () async {
      //arrange
      when(remoteDatasource.login(temail, tpassword))
          .thenAnswer((_) async => tUser);
      //act
      final result = await repositoryImpl.login(temail, tpassword);
      //assert
      expect(result, const Right(tUser));

      verify(remoteDatasource.login(temail, tpassword));
      verify(localDatasource.cacheToken(tUser.token));
      verify(localDatasource.cacheUser(tUser));
      verifyNoMoreInteractions(localDatasource);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Should logout a user', () async {
      //arrange
      when(remoteDatasource.logout()).thenAnswer((_) async => Future.value());
      //act
      final result = await repositoryImpl.logout();
      //assert
      expect(result, const Right(null));

      verify(remoteDatasource.logout());
      verify(localDatasource.clearToken());
      verify(localDatasource.clearUser());
      verifyNoMoreInteractions(localDatasource);
      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('device offline tests', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('Should return failure and NOT call remote signUp when offline',
        () async {
      // act
      final result = await repositoryImpl.signUp(tuserName, temail, tpassword);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(remoteDatasource);
      verifyZeroInteractions(localDatasource);
    });

    test('Should return failure and NOT call remote login when offline',
        () async {
      // act
      final result = await repositoryImpl.login(temail, tpassword);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(remoteDatasource);
      verifyZeroInteractions(localDatasource);
    });

    test('Should return failure and NOT call remote logout when offline',
        () async {
      // act
      final result = await repositoryImpl.logout();

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(remoteDatasource);
      verifyZeroInteractions(localDatasource);
    });
  });




}
