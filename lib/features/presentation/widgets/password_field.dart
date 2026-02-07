import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'auth_field.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> isObscureNotifier;
  final ValueNotifier<PasswordStrength?>? strengthNotifier;
  final String hintText;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.isObscureNotifier,
    this.strengthNotifier,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isObscureNotifier,
      builder: (context, isObscure, child) {
        return AuthField(
          hintText: hintText,
          controller: controller,
          isPassword: true,
          isObscure: isObscure,
          keyboardType: TextInputType.visiblePassword,
          toggleVisibility: () {
            isObscureNotifier.value = !isObscureNotifier.value;
          },
          onChanged: (value) {
            if (strengthNotifier != null) {
              strengthNotifier!.value = PasswordStrength.calculate(text: value);
            } else {
              return;
            }
          },
          validator: validator,
        );
      },
    );
  }
}