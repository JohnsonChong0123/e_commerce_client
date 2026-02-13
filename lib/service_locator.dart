import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'features/data/repositories/auth_repository_impl.dart';
import 'features/data/sources/local/user_local_data.dart';
import 'features/data/sources/remote/auth_remote_data.dart';
import 'features/domain/repositories/auth/auth_repository.dart';
import 'features/domain/usecases/auth/login.dart';
import 'features/domain/usecases/auth/sign_up.dart';
import 'features/presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

/// Initializes all application dependencies.
///
/// This function registers feature-level dependencies
/// following Clean Architecture layers:
/// - External
/// - Data layer
/// - Domain layer
/// - Presentation layer
///
/// It must be called before the app starts.
Future<void> initServiceLocator() async {
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => sl<DioClient>().dio);

  /// Registers all dependencies related to the authentication feature.
  _initAuth();

  /// Registers all dependencies related to the user feature.
  _initUser();
}

void _initAuth() {
  sl
    // Data layer: Remote data source
    ..registerLazySingleton<AuthRemoteData>(() => AuthRemoteDataImpl(dio: sl()))
    // Data layer: Repository implementation
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteData: sl(), userLocalData: sl()),
    )
    // Domain layer: Use case
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => Login(sl()))
    // Presentation layer: BLoC
    ..registerFactory(() => AuthBloc(signUp: sl(), login: sl()));
}

void _initUser() {
  sl
    // External dependency: FlutterSecureStorage
    ..registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage())
    // Data layer: Local data source
    ..registerLazySingleton<UserLocalData>(
      () => UserLocalDataImpl(flutterSecureStorage: sl()),
    );
}
