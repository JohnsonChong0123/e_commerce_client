import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/external/facebook/facebook_auth_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockLoginResult extends Mock implements LoginResult {}

class MockAccessToken extends Mock implements AccessToken {}

void main() {
  late FacebookAuthService service;
  late MockFacebookAuth mockAuth;
  late MockLoginResult mockResult;

  setUp(() {
    mockAuth = MockFacebookAuth();
    mockResult = MockLoginResult();
    service = FacebookAuthServiceImpl(facebookAuth: mockAuth);
  });

  test('should return access token when login success', () async {
    const tIdToken = 'test_id_token_12345';

    final mockAccessToken = MockAccessToken();
    // arrange
    when(
      () => mockAuth.login(permissions: ['email', 'public_profile']),
    ).thenAnswer((_) async => mockResult);
    when(() => mockResult.status).thenReturn(LoginStatus.success);
    when(() => mockResult.accessToken).thenReturn(mockAccessToken);
    when(() => mockAccessToken.token).thenReturn(tIdToken);

    // act
    final token = await service.getAccessToken();

    // assert
    expect(token, tIdToken);
  });

  test(
    'should throw ServerException when result status is not LoginStatus.success',
    () async {
      // arrange
      when(
        () => mockAuth.login(permissions: ['email', 'public_profile']),
      ).thenAnswer((_) async => mockResult);
      when(() => mockResult.status).thenReturn(LoginStatus.failed);

      // act & assert
      expect(() => service.getAccessToken(), throwsA(isA<ServerException>()));
    },
  );

  test('should throw ServerException when access token is null', () async {
    // arrange
    when(
      () => mockAuth.login(permissions: ['email', 'public_profile']),
    ).thenAnswer((_) async => mockResult);
    when(() => mockResult.status).thenReturn(LoginStatus.success);
    when(() => mockResult.accessToken).thenReturn(null);

    // act & assert
    expect(() => service.getAccessToken(), throwsA(isA<ServerException>()));
  });

  test(
    'should throw ServerException when facebook login throws an exception',
    () async {
      // arrange
      when(
        () => mockAuth.login(permissions: ['email', 'public_profile']),
      ).thenThrow(Exception('Facebook login error'));

      // act & assert
      expect(() => service.getAccessToken(), throwsA(isA<ServerException>()));
    },
  );
}
