import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_provider.dart';
import 'image_toggle_switch.dart';

class ToggleLanguage extends StatelessWidget {
  const ToggleLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    return ImageToggleSwitch(
      images: ["assets/images/LR.png", "assets/images/EG.png"],
      initialIndex: provider.locale.languageCode == "ar" ? 1 : 0,
      onChanged: (int value) {

          provider.setLocale(context);

      },
    );
  }
}
