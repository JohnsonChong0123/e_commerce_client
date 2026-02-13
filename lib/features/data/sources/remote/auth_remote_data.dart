import 'package:dio/dio.dart';
import '../../../../core/errors/exception.dart';
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
}

class AuthRemoteDataImpl implements AuthRemoteData {
  final Dio dio;
  AuthRemoteDataImpl({required this.dio});
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
    } on DioException catch (e) {
      print(e);
      if (e.error is ServerException) {
        throw e.error as ServerException;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
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
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw e.error as ServerException;
      }
      throw ServerException('An unexpected error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
