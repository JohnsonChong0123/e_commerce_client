import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract interface class FacebookAuthService {
  Future<String> getAccessToken();
}

class FacebookAuthServiceImpl implements FacebookAuthService {
  final FacebookAuth facebookAuth;

  FacebookAuthServiceImpl({required this.facebookAuth});

  @override
  Future<String> getAccessToken() async {
    try {
      // 1. trigger the Facebook login flow
      final result = await facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      // 2. check the login result status
      if (result.status != LoginStatus.success) {
        throw ServerException('Facebook login failed');
      }

      // 3. retrieve the access token
      final token = result.accessToken?.token;

      // 4. check if the token is null
      if (token == null) {
        throw ServerException('Access token is null');
      }

      return token;
    } catch (e) {
      throw ServerException('Facebook login error: $e');
    }
  }
}
