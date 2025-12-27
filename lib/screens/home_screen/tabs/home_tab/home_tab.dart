import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/models/task_model.dart';
import 'package:evently_app/screens/home_screen/tabs/home_tab/widgets/home_tab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/base_theme.dart';
import '../../../../models/fire_base/firebase_manager.dart';
import '../../../../providers/my_provider.dart';
import '../../../../providers/event_filter_provider.dart';
import 'widgets/event_item_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    var categoryProvider = Provider.of<EventFilterProvider>(context);

    final bool isDark = provider.themeMode == ThemeMode.dark;
    final background = isDark
        ? BaseTheme.dark.scaffoldBackgroundColor
        : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark
            ? BaseTheme.dark.scaffoldBackgroundColor
            : AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: background,
        appBar: HomeTabAppBar(isDark: isDark, provider: provider),

        body: StreamBuilder<QuerySnapshot<TaskModel>>(
          stream: FirebaseManager.getEvent(categoryProvider.selectedCategory),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong 😢"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No tasks yet 👀\nStart by adding your first task ✨",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final tasks = snapshot.data!.docs.map((doc) => doc.data()).toList();

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 60),

              itemCount: tasks.length,
              separatorBuilder: (_, __) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                return EventItemWidget(model: tasks[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
