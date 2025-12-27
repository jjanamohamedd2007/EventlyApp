import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_provider.dart';
import 'image_toggle_switch.dart';

class ToggleTheme extends StatelessWidget {
  const ToggleTheme({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    bool isDark = provider.themeMode == ThemeMode.dark;

    return ImageToggleSwitch(
      images: [
        "assets/images/Sun.png",
        "assets/images/Moon.png",
      ],
      initialIndex: isDark ? 1 : 0,
      onChanged: (int value) {
        provider.changeThemeMode();
      },
    );
  }
}
