import 'dart:convert';

import 'package:ecommerce_app/features/auth/data/models/auth_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late final AuthModel authModel;
  late final Map<String, dynamic> userJson;
  setUp(() {
    userJson = jsonDecode(fixture('user.json'));
    authModel = AuthModel.fromJson(userJson);
  });
  test('Should return a result that is a subtype of the Auth model', () async {
    expect(authModel, isA<AuthModel>());
  });

  test('Should get valid model from from json', () async {
    final result = AuthModel.fromJson(userJson);
    expect(result, authModel);
  });

  test('Should get valid json file from the model', () async {
    final result = authModel.toJson();
    expect(result, userJson);
  });
}
