import 'package:dio/dio.dart';

import '../../../data/sources/local/user_local_data.dart';
import '../../../data/sources/remote/auth_remote_data.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final UserLocalData userLocalData;
  final AuthRemoteData Function() getAuthRemoteData;

  AuthInterceptor({
    required this.dio,
    required this.userLocalData,
    required this.getAuthRemoteData,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // get token from local data
    final token = await userLocalData.getAccessToken();

    // if token exists, add it to the header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // continue with the request
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requiredAuth = err.requestOptions.extra['requiredAuth'] ?? true;
    // if the error is 401 and the request requires authentication, 
    // try to refresh the token
    if (err.response?.statusCode == 401 && requiredAuth) {
      try {
        // refresh the token
        final newToken = await _refreshToken();

        // retry the original request with the new token
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        // create a new request with the updated options
        final response = await dio.fetch(requestOptions);

        // resolve the original request with the new response
        return handler.resolve(response);
      } catch (_) {
        // if refreshing the token fails, reject the original error
        return handler.reject(err);
      }
    }
    // if the error is not 401 or 
    // the request does not require 
    // authentication, move to the next interceptor
    handler.next(err);
  }

  Future<String> _refreshToken() async {
    // get refresh token from local data
    final refreshToken = await userLocalData.getRefreshToken();

    // if refresh token is null, throw an exception
    if (refreshToken == null) {
      throw Exception('Session expired');
    }

    // call the refresh token API
    final newToken = await getAuthRemoteData().refreshToken(refreshToken);

    // if the new token is null, throw an exception
    if (newToken == null) {
      throw Exception('Failed to refresh token');
    }

    // save the new token to local data
    await userLocalData.setAccessToken(newToken);

    return newToken;
  }
}
