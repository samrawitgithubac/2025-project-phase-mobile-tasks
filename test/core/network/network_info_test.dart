import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
final tHasConnection = Future.value(true);
void main() {
  late NetworkInfoImp networkInfoImp;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImp = NetworkInfoImp(mockInternetConnectionChecker);
  });
  group('isConnected', () {
    test('Should call the hasConnection', () async {
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnection);
      final result = networkInfoImp.isConnected;
      expect(result, tHasConnection);
      verify(mockInternetConnectionChecker.hasConnection);
    });
  });
}
