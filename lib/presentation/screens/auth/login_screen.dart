import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_button/sign_button.dart';
import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../core/common/utils/show_snackbar.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Login", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Add your details to login"),
              const SizedBox(height: 50),
              const LoginForm(),
              const SizedBox(height: 10),
              GestureDetector(
                child: const Text('Forget your password?'),
                onTap: () {
                  // TODO: Forget Password Screen
                },
              ),
              const SizedBox(height: 50),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    showSnackBar(context, state.message);
                  } else if (state is AuthAuthenticated) {
                    showSnackBar(context, "Login Successful");
                    // context.go(AppRouter.home);
                  }
                },
                builder: (context, state) {
                  final isGoogleLoading =
                      state is AuthLoading &&
                      state.type == AuthLoadingType.google;

                  if (isGoogleLoading) {
                    return const Loader();
                  } else {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SignInButton(
                        elevation: 2,
                        buttonType: ButtonType.google,
                        width: double.infinity,
                        padding: 10,
                        onPressed: () async {
                          context.read<AuthBloc>().add(AuthGoogleLogin());
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    showSnackBar(context, state.message);
                  } else if (state is AuthAuthenticated) {
                    showSnackBar(context, "Login Successful");
                    // context.go(AppRouter.home);
                  }
                },
                builder: (context, state) {
                  final isFacebookLoading =
                      state is AuthLoading &&
                      state.type == AuthLoadingType.facebook;

                  if (isFacebookLoading) {
                    return const Loader();
                  } else {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SignInButton(
                        elevation: 2,
                        buttonType: ButtonType.facebook,
                        width: double.infinity,
                        padding: 10,
                        onPressed: () async {
                          context.read<AuthBloc>().add(AuthFacebookLogin());
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.go(AppRouter.signUp);
              },
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have account? ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColor.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isObscurePassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isObscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AuthField(
            key: const Key("emailField"),
            hintText: "Email",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20.0),
          PasswordField(
            key: const Key("passwordField"),
            controller: _passwordController,
            isObscureNotifier: _isObscurePassword,
            hintText: "Password",
          ),
          const SizedBox(height: 20.0),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthAuthenticated) {
                showSnackBar(context, "Login Successful");
                //   context.go(AppRouter.home);
              }
            },
            builder: (context, state) {
              final isLoginLoading =
                  state is AuthLoading && state.type == AuthLoadingType.normal;
              if (isLoginLoading) {
                return const Loader();
              } else {
                return AppButton(
                  key: const Key('loginButton'),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        AuthLogin(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  title: "Login",
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
