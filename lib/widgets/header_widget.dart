import 'package:flutter/cupertino.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Center(
          child: Image.asset(
      
            "assets/images/LogoHorizontal.png",
          ),
      
        ),
      ),
    );
  }
}
