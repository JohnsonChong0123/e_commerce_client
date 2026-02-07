import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final ButtonStyle? buttonStyle;
  const AppButton({
    required this.onPressed,
    required this.title,
    this.buttonStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}