import 'package:e_commerce_client/presentation/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entity/product_entity.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
// import '../../presentation/cubits/cart/cart_cubit.dart';
import '../../presentation/cubits/product/product_cubit.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product/product_details_screen.dart';
import '../../service_locator.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String productDetails = '/productDetails';
  static const String cart = '/cart';

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signUp,
          name: 'signUp',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => BlocProvider(
            create: (context) => ProductCubit(getProducts: sl()),
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: productDetails,
          name: 'productDetails',
          redirect: (context, state) {
            if (state.extra is! ProductEntity) return AppRouter.home;
            return null;
          },
          builder: (context, state) {
            final product = state.extra as ProductEntity;
            return
            // BlocProvider(
            //   create: (context) => CartCubit(addToCart: sl(), getCart: sl(), removeCartItem: sl()),
            //   child:
            ProductDetailScreen(product: product);
            // ,
            // );
          },
        ),
        GoRoute(
          path: cart,
          name: 'cart',
          builder: (context, state) =>
              // BlocProvider(
              //   create: (context) =>
              //       CartCubit(addToCart: sl(), getCart: sl(), removeCartItem: sl())
              //         ..getCart(),
              // child:
              const CartScreen(),
        ),
        // ),
      ],
    );
  }
}
