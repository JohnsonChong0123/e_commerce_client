import 'package:dio/dio.dart';
import '../../features/data/sources/local/user_local_data.dart';
import '../../features/data/sources/remote/auth_remote_data.dart';
import '../common/constants/server_constant.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required UserLocalData userLocalData,
    required AuthRemoteData Function() getAuthRemoteData,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: ServerConstant.serverURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(
        dio: dio,
        userLocalData: userLocalData,
        getAuthRemoteData: getAuthRemoteData,
      ),
      ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }
}