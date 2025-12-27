
import 'package:flutter/material.dart';

class EventFilterProvider extends ChangeNotifier {
  String selectedCategory = "All";

  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    notifyListeners();
  }
}
