import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class AppAlertDialog extends StatelessWidget {
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  final String title;
  final String content;

  const AppAlertDialog({
    super.key,
    required this.onYesPressed,
    required this.onNoPressed,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: onNoPressed,
          child: const Text(
            'No',
            style: TextStyle(color: AppColor.green),
          ),
        ),
        TextButton(
          onPressed: onYesPressed,
          child: const Text(
            'Yes',
            style: TextStyle(color: AppColor.green),
          ),
        ),
      ],
      title: Text(title),
      content: Text(content),
    );
  }
}