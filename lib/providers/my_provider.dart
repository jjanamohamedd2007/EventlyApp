import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';

class MyProvider extends ChangeNotifier {
  List<TaskModel> favoriteTasks = [];

  Locale _locale = const Locale("en");

  Locale get locale => _locale;

  ThemeMode themeMode = ThemeMode.light;

  void changeThemeMode() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLocale(BuildContext context) {
    _locale = _locale.languageCode == "en"
        ? const Locale("ar")
        : const Locale("en");
    context.setLocale(_locale);
    notifyListeners();
  }
}
