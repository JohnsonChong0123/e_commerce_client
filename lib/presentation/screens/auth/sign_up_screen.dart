import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import '../../../core/common/utils/show_snackbar.dart';
import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/themes/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/password_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add your details to sign up"),
              SizedBox(height: 50),
              SignUpForm(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.go(AppRouter.login);
              },
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text: 'Login',
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

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isObscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isObscureConfirmPassword = ValueNotifier<bool>(
    true,
  );

  final _passNotifier = ValueNotifier<PasswordStrength?>(null);
  final _confirmPassNotifier = ValueNotifier<PasswordStrength?>(null);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isObscurePassword.dispose();
    _isObscureConfirmPassword.dispose();
    _passNotifier.dispose();
    _confirmPassNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        // ListView(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        children: [
          AuthField(
            key: const Key('firstNameField'),
            hintText: "First Name",
            controller: _firstNameController,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          AuthField(
            key: const Key('lastNameField'),
            hintText: "Last Name",
            controller: _lastNameController,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          AuthField(
            key: const Key('emailField'),
            hintText: "Email",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          AuthField(
            key: const Key('phoneField'),
            hintText: "Phone Number",
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          PasswordField(
            key: const Key('passwordField'),
            controller: _passwordController,
            isObscureNotifier: _isObscurePassword,
            strengthNotifier: _passNotifier,
            hintText: "Password",
          ),
          const SizedBox(height: 5),
          PasswordStrengthChecker(strength: _passNotifier),
          const SizedBox(height: 20),
          PasswordField(
            key: const Key('confirmPasswordField'),
            controller: _confirmPasswordController,
            isObscureNotifier: _isObscureConfirmPassword,
            strengthNotifier: _confirmPassNotifier,
            hintText: "Confirm Password",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              } else if (value != _passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(PasswordStrength.instructions),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccess) {
                showSnackBar(
                  context,
                  "Successfully signed up! Please enter your email and password to login.",
                );
                context.go(AppRouter.login);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              } else {
                return AppButton(
                  key: const Key('signUpButton'),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        AuthSignUp(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  title: 'Sign Up',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
