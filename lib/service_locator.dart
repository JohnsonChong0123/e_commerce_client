import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/data/repositories/auth_repository_impl.dart';
import 'features/data/sources/auth_remote_data.dart';
import 'features/domain/repositories/auth/auth_repository.dart';
import 'features/domain/usecases/auth/sign_up.dart';
import 'features/presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  _initAuth();
}

void _initAuth() {
  sl
    ..registerLazySingleton<Dio>(() => Dio()) // Dio

    ..registerLazySingleton<AuthRemoteData>(
      () => AuthRemoteDataImpl(dio: sl()),
    ) // AuthRemoteData

    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl()),
    ) // AuthRepository

    ..registerLazySingleton(() => SignUp(sl())) // UseCases
    
    ..registerFactory(() => AuthBloc(signUp: sl())); // Blocs
}
