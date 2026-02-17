import 'package:dio/dio.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/external/facebook/facebook_auth_service.dart';
import '../../../../core/external/google/google_auth_service.dart';
import '../../models/auth_response.dart';

abstract interface class AuthRemoteData {
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> loginWithGoogle();

  Future<AuthResponse> loginWithFacebook();
}

class AuthRemoteDataImpl implements AuthRemoteData {
  final Dio dio;
  final GoogleAuthService googleAuthService;
  final FacebookAuthService facebookAuthService;

  AuthRemoteDataImpl({
    required this.dio,
    required this.googleAuthService,
    required this.facebookAuthService,
  });
  @override
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await dio.post(
        '/auth/register',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "phone": phone,
        },
      );
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<AuthResponse> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {"email": email, "password": password},
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<AuthResponse> loginWithGoogle() async {
    try {
      final tokenId = await googleAuthService.getIdToken();

      final response = await dio.post(
        '/auth/google',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {"id_token": tokenId},
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<AuthResponse> loginWithFacebook() async {
    try {
      final accessToken = await facebookAuthService.getAccessToken();

      final response = await dio.post(
        '/auth/facebook',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {"access_token": accessToken},
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      _handleError(e);
    }
  }

  Never _handleError(Object e) {
    if (e is DioException && e.error is ServerException) {
      throw e.error as ServerException;
    }
    if (e is DioException) {
      throw ServerException('An unexpected error occurred');
    }
    throw ServerException(e.toString());
  }
}
