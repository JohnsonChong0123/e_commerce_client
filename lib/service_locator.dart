import 'package:e_commerce_client/domain/usecases/cart/remove_cart_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/external/facebook/facebook_auth_service.dart';
import 'core/external/google/google_auth_service.dart';
import 'core/network/dio_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/sources/local/user_local_data.dart';
import 'data/sources/remote/auth_remote_data.dart';
import 'data/sources/remote/cart_remote_data.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/auth/check_auth_status.dart';
import 'domain/usecases/auth/facebook_login.dart';
import 'domain/usecases/auth/google_login.dart';
import 'domain/usecases/auth/login.dart';
import 'domain/usecases/auth/sign_up.dart';
import 'domain/usecases/cart/add_to_cart.dart';
import 'domain/usecases/cart/clear_cart.dart';
import 'domain/usecases/cart/get_cart.dart';
import 'domain/usecases/product/get_products.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'data/sources/remote/product_remote_data.dart';
import 'presentation/cubits/cart/cart_cubit.dart';
import 'presentation/cubits/product/product_cubit.dart';

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
  // Google Sign In - resgister as a singleton without initialization, since GoogleAuthService will handle it
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  // Google Auth Service - create an instance, initialize it, and register it as a singleton
  final googleAuthService = GoogleAuthServiceImpl(
    serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  // initalize Google Auth Service
  await googleAuthService.initialize();

  sl.registerLazySingleton<GoogleAuthService>(() => googleAuthService);

  // Facebook Auth - register the singleton instance provided by the package
  sl.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);

  // Facebook Auth Service - create an instance, initialize it, and register it as a singleton
  sl.registerLazySingleton<FacebookAuthService>(
    () => FacebookAuthServiceImpl(facebookAuth: sl()),
  );

  // Registers all dependencies related to the authentication feature.
  _initAuth();

  // Registers all dependencies related to the user feature.
  _initUser();

  // Registers all dependencies related to the product feature.
  _initProduct();

  // Registers all dependencies related to the cart feature.
  _initCart();

  sl.registerLazySingleton(
    () => DioClient(
      userLocalData: sl(),
      getAuthRemoteData: () => sl<AuthRemoteData>(),
    ),
  );
  sl.registerLazySingleton(() => sl<DioClient>().dio);
}

void _initAuth() {
  sl
    // Data layer: Remote data source
    ..registerLazySingleton<AuthRemoteData>(
      () => AuthRemoteDataImpl(
        dio: sl(),
        googleAuthService: sl(),
        facebookAuthService: sl(),
      ),
    )
    // Data layer: Repository implementation
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteData: sl(), userLocalData: sl()),
    )
    // Domain layer: Use case
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => GoogleLogin(sl()))
    ..registerLazySingleton(() => FacebookLogin(sl()))
    ..registerLazySingleton(() => CheckAuthStatus(sl()))
    // Presentation layer: BLoC
    ..registerFactory(
      () => AuthBloc(
        signUp: sl(),
        login: sl(),
        googleLogin: sl(),
        facebookLogin: sl(),
        checkAuthStatus: sl(),
      ),
    );
  // ..registerLazySingleton<AuthBloc>(
  //   () => AuthBloc(
  //     signUp: sl(),
  //     login: sl(),
  //     googleLogin: sl(),
  //     facebookLogin: sl(),
  //     checkAuthStatus: sl(),
  //   ),
  // );
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

void _initProduct() {
  sl
    // Data layer: Remote data source
    ..registerLazySingleton<ProductRemoteData>(
      () => ProductRemoteDataImpl(dio: sl()),
    )
    // Data layer: Repository implementation
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(productRemoteData: sl()),
    )
    // Domain layer: Use case
    ..registerLazySingleton(() => GetProducts(sl()))
    // Presentation layer: Cubit
    ..registerFactory(() => ProductCubit(getProducts: sl()));
}

void _initCart() {
  sl
    // Data layer: Remote data source
    ..registerLazySingleton<CartRemoteData>(() => CartRemoteDataImpl(dio: sl()))
    // Data layer: Repository implementation
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(cartRemoteData: sl()),
    )
    // Domain layer: Use case
    ..registerLazySingleton(() => AddToCart(sl()))
    ..registerLazySingleton(() => GetCart(sl()))
    ..registerLazySingleton(() => RemoveCartItem(sl()))
    ..registerLazySingleton(() => ClearCart(sl()))
    // Presentation layer: Cubit
    ..registerFactory(() => CartCubit(addToCart: sl(), getCart: sl(), removeCartItem: sl(), clearCart: sl()));
}
