import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/themes/app.theme.dart';
import 'features/presentation/blocs/auth/auth_bloc.dart';
import 'features/presentation/screens/auth/sign_up_screen.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initServiceLocator();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(signUp: sl()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SignUpScreen(),
    );
  }
}
