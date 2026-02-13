import 'package:go_router/go_router.dart';
import '../../features/presentation/screens/auth/login_screen.dart';
import '../../features/presentation/screens/auth/sign_up_screen.dart';
import '../../features/presentation/screens/home_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
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
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
