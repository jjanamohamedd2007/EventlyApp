import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ImageToggleSwitch extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final Function(int) onChanged;

  const ImageToggleSwitch({
    super.key,
    required this.images,
    this.initialIndex = 0,
    required this.onChanged,
  });

  @override
  State<ImageToggleSwitch> createState() => _ImageToggleSwitchState();
}

class _ImageToggleSwitchState extends State<ImageToggleSwitch> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    const double outerBorderWidth = 4; // البوردر الخارجي
    const double innerBorderWidth = 5; // البوردر الداخلي
    const double imageSize = 25; // حجم الصورة

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // الطول = الصورة + البوردر الداخلي + البوردر الخارجي
    final double containerHeight =
        imageSize + innerBorderWidth * 2 + outerBorderWidth * 2;

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.primary, width: outerBorderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.images.length, (index) {
          final String imagePath = widget.images[index];
          final bool isSelected = selectedIndex == index;
          final bool isSun = imagePath.contains("Sun");

          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onChanged(index);
                },
                child: Container(
                  width: imageSize + innerBorderWidth * 2,
                  height: imageSize + innerBorderWidth * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ✅ لو Sun ومختارة → الخلفية Primary
                    color: (isSun && isSelected)
                        ? AppColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: innerBorderWidth,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      color: () {
                        if (isSun && isSelected) {
                          // ✅ لو Sun ومختارة → الأيقونة لونها خلفية الشاشة
                          return Theme.of(context).scaffoldBackgroundColor;
                        } else if (isSun && !isSelected) {
                          // ✅ لو Sun ومش مختارة + دارك → الأيقونة Primary
                          return AppColors.primary;
                        }
                        return null; // الوضع العادي
                      }(),
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              if (index != widget.images.length - 1)
                const SizedBox(width: 30), // المسافة بين الصورتين
            ],
          );
        }),
      ),
    );
  }
}
