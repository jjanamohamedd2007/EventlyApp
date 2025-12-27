import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/base_theme.dart';
import '../providers/my_provider.dart';

class PickerLocationWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const PickerLocationWidget({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<MyProvider>(context).themeMode == ThemeMode.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 361,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.my_location,
                color: isDark
                    ? BaseTheme.dark.scaffoldBackgroundColor
                    : Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, color: AppColors.primary),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 20),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
