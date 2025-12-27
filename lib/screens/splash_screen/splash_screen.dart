import 'package:evently_app/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/base_theme.dart';
import '../../providers/my_provider.dart';
import '../login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () async {
        final prefs = await SharedPreferences.getInstance();
        final seenOnboarding = prefs.getBool('isOnboardingSeen') ?? false;

        if (seenOnboarding) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    final bool isDark = provider.themeMode == ThemeMode.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark
            ? BaseTheme.dark.scaffoldBackgroundColor
            : BaseTheme.light.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark
              ? BaseTheme.dark.scaffoldBackgroundColor
              : BaseTheme.light.scaffoldBackgroundColor,
        ),
        backgroundColor: isDark
            ? BaseTheme.dark.scaffoldBackgroundColor
            : BaseTheme.light.scaffoldBackgroundColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(child: Image.asset("assets/images/LogoVertical.png")),
        ),
      ),
    );
  }
}
