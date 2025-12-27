import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/models/task_model.dart';
import 'package:evently_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception('error');
    }
  }

  static CollectionReference<TaskModel> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) {
            return TaskModel.fromJson(snapshot.data()!);
          },
          toFirestore: (value, _) {
            return value.toJson();
          },
        );
  }

  static Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }

  static Future<UserModel?> readUserData(String id) async {
    var collection = getUsersCollection();
    DocumentSnapshot<UserModel> snapShot = await collection.doc(id).get();
    return snapShot.data();
  }

  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) {
            return UserModel.fromJson(snapshot.data()!);
          },
          toFirestore: (value, _) {
            return value.toJson();
          },
        );
  }

  static Future<void> addEvent(TaskModel model) {
    var collection = getTasksCollection();
    var docRef = collection.doc();
    model.id = docRef.id;
    return docRef.set(model);
  }

  static Future<void> addUser(UserModel model) {
    var collection = getUsersCollection();
    var docRef = collection.doc(model.id);
    return docRef.set(model);
  }

  static Stream<QuerySnapshot<TaskModel>> getEvent(String categoryName) {
    var collection = getTasksCollection().where(
      "userId",
      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
    );

    // لو category = All → رجّعي كلهم بالترتيب
    if (categoryName == "All") {
      return collection.orderBy("date", descending: false).snapshots();
    }

    // لو category غير All → رجّعي من غير ترتيب (علشان مفيش index)
    return collection.where("category", isEqualTo: categoryName).snapshots();
  }

  static Future<void> deleteTask(String id) {
    var collection = getTasksCollection();
    return collection.doc(id).delete();
  }

  static Future<void> updateTask(TaskModel model) {
    var collection = getTasksCollection();
    return collection.doc(model.id).update(model.toJson());
  }

  static createUser(
    String name,
    String location,
    String email,
    String password,

    Function onSuccess,
    Function onError,
    Function onLoading,
  ) async {
    try {
      onLoading();
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel model = UserModel(
        name: name,
        location: location,
        email: email,

        id: credential.user?.uid,

        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await addUser(model);
      await credential.user?.sendEmailVerification();
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError(e.message);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        onError(e.message);

        print('The account already exists for that email.');
      }
    } catch (e) {
      onError("Something went wrong");

      print(e);
    }
  }

  static Future<void> logIn(
    String email,
    String password,
    Function onSuccess,
    Function(String) onError,
    Function onLoading,
  ) async {
    try {
      onLoading();

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ هنا بنحدث بيانات المستخدم من السيرفر
      await credential.user!.reload();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        onSuccess();
      } else {
        onError("Email is not verified, please check your mail and verify it.");
      }
    } on FirebaseAuthException catch (e) {
      onError("Email or Password is not valid");
    } catch (e) {
      onError("Something went wrong. Please try again.");
    }
  }
}
