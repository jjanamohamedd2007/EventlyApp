import 'package:evently_app/models/fire_base/firebase_manager.dart';
import 'package:evently_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? userModel;
  User? currentUser;

  AuthProvider() {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      initUser();
    }
  }

  initUser() async {
    currentUser= FirebaseAuth.instance.currentUser;

    userModel = await FirebaseManager.readUserData(currentUser!.uid);
    notifyListeners();
  }
}
