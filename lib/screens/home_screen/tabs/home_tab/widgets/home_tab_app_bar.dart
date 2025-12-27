import 'package:evently_app/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/base_theme.dart';
import '../../../../../providers/event_filter_provider.dart';
import '../../../../../providers/my_provider.dart';

class HomeTabAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isDark;
  final MyProvider provider;

  const HomeTabAppBar({
    super.key,
    required this.isDark,
    required this.provider,
  });

  @override
  State<HomeTabAppBar> createState() => _HomeTabAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 120);
}

class _HomeTabAppBarState extends State<HomeTabAppBar> {
  final List<Map<String, String>> eventCategories = [
    {"name": "All", "icon": "assets/images/Vector.png"},
    {"name": "Book Club", "icon": "assets/images/bookopen.png"},
    {"name": "Sport", "icon": "assets/images/bike.png"},
    {"name": "Birthday", "icon": "assets/images/cake.png"},
    {"name": "Eating", "icon": "assets/images/iconeating.png"},
    {"name": "Exhibition", "icon": "assets/images/iconexhibition.png"},
    {"name": "Gaming", "icon": "assets/images/icongaming.png"},
    {"name": "Holiday", "icon": "assets/images/holidays.png"},
    {"name": "Meeting", "icon": "assets/images/iconbusiness.png"},
    {"name": "Workshop", "icon": "assets/images/iconworkshop.png"},
  ];

  @override
  Widget build(BuildContext context) {
    String selected = context.watch<EventFilterProvider>().selectedCategory;
var auth=Provider.of<AuthProvider>(context);
    return AppBar(
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: widget.isDark
          ? BaseTheme.dark.scaffoldBackgroundColor
          : AppColors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ======= HEADER =======
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// welcome text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back ✨",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            auth.userModel?.name ?? "Loading...",
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Image.asset(
                                "assets/images/Map_Pin.png",
                                width: 20,
                                height: 20,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                auth.userModel?.location ?? "Loading...",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )

                    ],
                  ),

                  /// theme & lang buttons
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          widget.provider.changeThemeMode();
                        },
                        child: Image.asset(
                          widget.provider.themeMode == ThemeMode.dark
                              ? "assets/images/Moon.png"
                              : "assets/images/sunny.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          widget.provider.setLocale(context);
                        },
                        child: Container(
                          width: 35,
                          height: 33,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: widget.isDark
                                ? AppColors.primary
                                : AppColors.white,
                          ),
                          child: Center(
                            child: Text(
                              "EN",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark
                                    ? BaseTheme.dark.scaffoldBackgroundColor
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ======= CATEGORY FILTER =======
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: eventCategories.length,
                  itemBuilder: (context, index) {
                    final category = eventCategories[index];
                    bool isSelected = selected == category["name"];

                    return InkWell(
                      onTap: () {
                        context
                            .read<EventFilterProvider>()
                            .changeCategory(category["name"]!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (widget.isDark
                              ? AppColors.primary
                              : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.isDark
                                ? AppColors.primary
                                : Colors.white,
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              category["icon"]!,
                              width: 20,
                              height: 20,
                              color: isSelected
                                  ? (widget.isDark
                                  ? Colors.white
                                  : AppColors.primary)
                                  : Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category["name"]!,
                              style: TextStyle(
                                color: isSelected
                                    ? (widget.isDark
                                    ? Colors.white
                                    : AppColors.primary)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
