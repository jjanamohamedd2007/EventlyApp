import 'package:evently_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Button_Widget extends StatelessWidget {
  final String text; // النص اللي هيظهر
  final VoidCallback onPressed; // الفانكشن اللي هيتنفذ

  const Button_Widget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 361,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
