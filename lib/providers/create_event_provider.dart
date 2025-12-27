import 'package:flutter/cupertino.dart';

class CreateEventProvider extends ChangeNotifier {
  List<Map<String, String>> eventCategories = [
    {
      "name": "Book Club",
      "icon": "assets/images/bookopen.png",
      "image": "assets/images/bookclub.png"
    },
    {
      "name": "Sport",
      "icon": "assets/images/bike.png",
      "image": "assets/images/sport.png"
    },
    {
      "name": "Birthday",
      "icon": "assets/images/cake.png",
      "image": "assets/images/birthday.png"
    },
    {
      "name": "Eating",
      "icon": "assets/images/iconeating.png",
      "image": "assets/images/eating.png"
    },
    {
      "name": "Exhibition",
      "icon": "assets/images/iconexhibition.png",
      "image": "assets/images/exhibition.png"
    },
    {
      "name": "Gaming",
      "icon": "assets/images/icongaming.png",
      "image": "assets/images/gaming.png"
    },
    {
      "name": "Holiday",
      "icon": "assets/images/holidays.png",
      "image": "assets/images/holiday.png"
    },
    {
      "name": "Meeting",
      "icon": "assets/images/iconbusiness.png",
      "image": "assets/images/meeting.png"
    },
    {
      "name": "Workshop",
      "icon": "assets/images/iconworkshop.png",
      "image": "assets/images/workshop.png"
    },
  ];

  int selectedCategory = 0;
  bool isLoading = false;
  String get selectedCategoryName=>eventCategories[selectedCategory]["name"]!;

  void selectCategory(int index)async {
    isLoading=true;
    notifyListeners();


    await Future.delayed(const Duration(seconds: 1));

    selectedCategory = index;
    isLoading = false;
    notifyListeners();
  }
}
