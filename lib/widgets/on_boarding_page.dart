import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/widgets/toggle_language.dart';
import 'package:evently_app/widgets/toggle_theme.dart';
import 'package:flutter/cupertino.dart';

import '../core/theme/dark_theme.dart';
import '../core/theme/light_theme.dart';

class OnBoardingPage extends StatelessWidget {
  final Map<String, String> page;
  final bool isDark;
  final bool showToggles;

  const OnBoardingPage({
    super.key,
    required this.page,
    required this.isDark,
    this.showToggles = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              child: Center(
                child: Image.asset(
                  page['image']!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              page['title']!,
              style: isDark ? DarkTheme.textMedium : LightTheme.textMedium,
            ),
            const SizedBox(height: 8),

            Text(
              page['body']!,
              style: isDark ? DarkTheme.textSmall : LightTheme.textSmall,
            ),
            const SizedBox(height: 16),

            if (showToggles) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr("language"),
                    style: isDark ? DarkTheme.textMedium : LightTheme.textMedium,
                  ),
                  ToggleLanguage(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr("theme"),
                    style: isDark ? DarkTheme.textMedium : LightTheme.textMedium,
                  ),
                  ToggleTheme(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
