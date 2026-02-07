import 'package:dio/dio.dart';
import '../../../core/common/constants/server_constant.dart';
import '../../../core/errors/exception.dart';

abstract interface class AuthRemoteData {
  Future<void> signUpWithEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
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
      final response = await dio.post(
        '${ServerConstant.serverURL}/auth/register',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "phone": phone,
        },
      );
      if (response.statusCode != 200) {
        throw ServerException('Failed to register user');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
