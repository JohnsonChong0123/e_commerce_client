import 'package:dio/dio.dart';
import '../../errors/exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.response?.statusCode) {
      case 400:
        errorMessage = 'Invalid request';
        break;
      case 401:
        errorMessage = 'Invalid email or password';
        break;
      case 404:
        errorMessage = 'Resource not found';
        break;
      case 409:
        errorMessage = 'Email has already been used';
        break;
      case 500:
        errorMessage = 'Server error, please try again later';
        break;
      default:
        errorMessage = err.message ?? 'Network error';
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ServerException(errorMessage),
        response: err.response,
        type: err.type,
      ),
    );
  }
}
