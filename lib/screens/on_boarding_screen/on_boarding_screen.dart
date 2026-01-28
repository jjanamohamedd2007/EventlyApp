import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/my_provider.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/on_boarding_buttons.dart';
import '../../widgets/on_boarding_page.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = "OnBoardingScreen";
  Future<void> skipOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingSeen', true);

    Navigator.pushReplacementNamed(context, '/login');
  }


  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    final bool isDark = provider.themeMode == ThemeMode.dark;

    final pagesData = [
      {
        'title': tr("introduction_title_one"),
        'body': tr("introduction_description_one"),
        'image': "assets/images/one.png",
      },
      {
        'title': tr("introduction_title_two"),
        'body': tr("introduction_description_two"),
        'image': "assets/images/two.png",
      },
      {
        'title': tr("introduction_title_three"),
        'body': tr("introduction_description_three"),
        'image': "assets/images/three.png",
      },
      {
        'title': tr("introduction_title_four"),
        'body': tr("introduction_description_four"),
        'image': "assets/images/four.png",
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            HeaderWidget(),
            const SizedBox(height: 12),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                itemCount: pagesData.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final page = pagesData[index];
                  final showToggles = index == 0;
                  return OnBoardingPage(
                    page: page,
                    isDark: isDark,
                    showToggles: showToggles,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            OnBoardingButtons(
              currentIndex: _currentIndex,
              controller: _controller,
              totalPages: pagesData.length,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
