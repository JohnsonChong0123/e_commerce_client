import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app.theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/cubits/cart/cart_cubit.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckStatus()),
        ),
        BlocProvider(
          create: (_) => CartCubit(
            addToCart: sl(),
            getCart: sl(),
            removeCartItem: sl(),
            clearCart: sl(),
          ),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _router = AppRouter.router(authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final currentLocation =
            _router.routerDelegate.currentConfiguration.uri.path;

        if (state is AuthUnauthenticated) {
          if (currentLocation != '/login' && currentLocation != '/signUp') {
            _router.go('/login');
          }
        } else if (state is AuthAuthenticated) {
          if (currentLocation == '/' ||
              currentLocation == '/login' ||
              currentLocation == '/signUp') {
            _router.go('/home');
          }
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routerConfig: _router,
      ),
    );
  }
}
