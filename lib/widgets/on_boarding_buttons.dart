import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/dark_theme.dart';
import '../core/theme/light_theme.dart';
import '../providers/my_provider.dart';
import '../screens/login_screen/login_screen.dart';
import 'button_widget.dart';

class OnBoardingButtons extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final PageController controller;

  const OnBoardingButtons({
    required this.currentIndex,
    required this.totalPages,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<MyProvider>(context).themeMode == ThemeMode.dark;

    // أول صفحة
    if (currentIndex == 0) {
      return SizedBox(
        width: double.infinity,
        child: Button_Widget(
          text: tr("lets_start"),
          onPressed: () {
            controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentIndex > 1)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              side: BorderSide(color: AppColors.primary, width: 2),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              controller.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Icon(Icons.arrow_back, color: AppColors.primary, size: 25),
          )
        else
          const SizedBox(width: 56),

        Row(
          children: List.generate(totalPages - 1, (index) {
            bool active = currentIndex - 1 == index;
            return Container(
              width: active ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: active
                    ? (isDark
                    ? DarkTheme.textMedium.color
                    : LightTheme.textMedium.color)
                    : (isDark
                    ? DarkTheme.textSmall.color
                    : LightTheme.textSmall.color),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            side: BorderSide(color: AppColors.primary, width: 2),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: () async {
            if (currentIndex == totalPages - 1) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isOnboardingSeen', true);

              Navigator.pushReplacementNamed(
                  context, LoginScreen.routeName);
            } else {
              controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Icon(Icons.arrow_forward, color: AppColors.primary, size: 25),
        ),
      ],
    );
  }
}
