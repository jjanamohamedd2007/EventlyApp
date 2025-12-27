class UserModel {
  String? name;
  String? location;
  String? email;
  String? id;


  int? createdAt;




  UserModel({


    required this.name,
    required this.location,
    required this.email,

    required this.id,
    required this.createdAt,
  });
 
  UserModel.fromJson(Map<String, dynamic> json)
    : this(
    name: json["name"],
    location: json["location"],
    email: json["email"],

    id: json["id"],


        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() {
    return {
      "name":name,
      "location":location,
      "email":email,

      "id":id,
      "createdAt":createdAt,
    };
  }
}
