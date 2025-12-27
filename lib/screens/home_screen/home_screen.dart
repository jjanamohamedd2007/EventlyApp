import 'package:evently_app/screens/home_screen/tabs/home_tab/home_tab.dart';
import 'package:evently_app/screens/home_screen/tabs/map_tab/map_tab.dart';
import 'package:evently_app/screens/home_screen/tabs/love_tab/love_tab.dart';
import 'package:evently_app/screens/home_screen/tabs/profile_tab/profile_tab.dart';
import 'package:evently_app/screens/create_event_screen/create_event_screen.dart';
import 'package:evently_app/core/theme/app_colors.dart';
import 'package:evently_app/core/theme/base_theme.dart';
import 'package:evently_app/providers/home_navigation_provider.dart';
import 'package:evently_app/providers/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/custom_floating_action_button.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ يمنع إعادة البناء عند التبديل بين التابات

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ ضروري عشان الـ mixin يشتغل

    final provider = Provider.of<MyProvider>(context);
    final navProvider = Provider.of<HomeNavigationProvider>(context);
    final bool isDark = provider.themeMode == ThemeMode.dark;
    List<TaskModel> favoriteTasks = [];

    final List<Widget> pages =  [
      HomeTab(key: PageStorageKey('homeTab')),
      MapTab(key: PageStorageKey('mapTab'), fromCreatePage: false,),
      LoveTab(key: PageStorageKey('loveTab'), ),
      ProfileTab(key: PageStorageKey('profileTab')),
    ];

    return Scaffold(
        resizeToAvoidBottomInset: false, // ✅ يمنع تحريك الزر عند ظهور الكيبورد أو SnackBar
        extendBody: true,
      backgroundColor: isDark
          ? BaseTheme.dark.scaffoldBackgroundColor
          : BaseTheme.light.scaffoldBackgroundColor,

      // ✅ الصفحة بتفضل محفوظة وما بتتهزش
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: pages,
      ),

      floatingActionButton: CustomFloatingActionButton(
        isDark: isDark,
        onPressed: () async {
          await Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => const CreateEventScreen(),
            transitionDuration: Duration.zero, // 🔥 مفيش حركة دخول
            reverseTransitionDuration: Duration.zero, // 🔥 مفيش حركة خروج
          ));
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navProvider.currentIndex,
        isDark: isDark,
        onTap: (index) => navProvider.setIndex(index),
      ),
    );
  }
}
