import 'package:flutter/material.dart';
import '../../../core/common/utils/validation_utils.dart';
import '../../../core/themes/app_colors.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? toggleVisibility;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isObscure = true,
    this.toggleVisibility,
    this.onChanged,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) {
              return "Please enter your ${hintText.toLowerCase()}";
            }

            if (hintText.toLowerCase() == "email" &&
                !ValidationUtils.isValidEmail(value)) {
              return "Please enter a valid ${hintText.toLowerCase()}";
            }

            if (hintText.toLowerCase() == "phone number" &&
                !ValidationUtils.isValidPhone(value)) {
              return "Please enter a valid ${hintText.toLowerCase()}";
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.primary,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }
}