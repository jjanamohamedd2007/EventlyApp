import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/base_theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 4,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.white, width: 4),
      ),
      backgroundColor: isDark
          ? BaseTheme.dark.scaffoldBackgroundColor
          : AppColors.primary,
      onPressed: onPressed,
      child: const Icon(Icons.add, color: AppColors.white, size: 30),
    );
  }
}
