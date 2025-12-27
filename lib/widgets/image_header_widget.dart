import 'package:flutter/cupertino.dart';

class ImageHeaderWidget extends StatelessWidget {
  const ImageHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Image.asset("assets/images/LogoVertical.png")),
    );
  }
}
