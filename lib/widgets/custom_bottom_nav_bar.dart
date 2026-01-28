import 'package:evently_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../core/theme/base_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDark
        ? BaseTheme.dark.scaffoldBackgroundColor
        : AppColors.primary;

    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,


      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white,

      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
      ),

      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: ImageIcon(
            AssetImage(
              currentIndex == 0
                  ? "assets/images/HomeFill.png"
                  : "assets/images/Home.png",
            ),
            color: AppColors.white,
          ),
        ),
        BottomNavigationBarItem(
          label: "Map",
          icon: ImageIcon(
            AssetImage(
              currentIndex == 1
                  ? "assets/images/Map_PinFill.png"
                  : "assets/images/Map_Pin.png",
            ),
            color: AppColors.white,
          ),
        ),
        BottomNavigationBarItem(
          label: "Love",
          icon: ImageIcon(
            AssetImage(
              currentIndex == 2
                  ? "assets/images/HeartFill.png"
                  : "assets/images/Heart.png",
            ),
            color: AppColors.white,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: ImageIcon(
            AssetImage(
              currentIndex == 3
                  ? "assets/images/User_01Fill.png"
                  : "assets/images/User_01.png",
            ),
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
