import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String title;
  String description;
  int categoryIndex;
  String category;

  DateTime date;
  String time;
  bool isDone;
  bool isFavorite;
  String location;
  String userId;

  TaskModel({
    this.id  ,
    required this.title,
    required this.description,

    required this.categoryIndex,
    required this.category,
    required this.date,

    required this.time,
    this.isDone = false,
    this.isFavorite = false,
    this.location = "",

    required this.userId,
  });

  TaskModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json["id"] ,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
    categoryIndex: json["categoryIndex"] ?? 0,
    category: json["category"] ?? "",

    date: (json["date"] as Timestamp?)?.toDate() ?? DateTime.now(),
        time: json["time"] ?? "",
        isDone: json["isDone"] ?? false,
        isFavorite: json["isFavorite"] ?? false,

        location: json["location"] ?? "",
        userId: json["userId"] ?? "",
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "categoryIndex": categoryIndex,
      "category": category,

      "date": Timestamp.fromDate(date),

      "time": time,
      "isDone": isDone,

      "isFavorite": isFavorite,
      "location": location,
      "userId": userId,
    };
  }
}
