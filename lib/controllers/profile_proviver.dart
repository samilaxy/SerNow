// import 'package:flutter/material.dart';
// import 'package:serv_now/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileProvider extends ChangeNotifier {

//  final _db = FirebaseFirestore.instance;
//  String _message = "";
//  String get message => _message;
 
//   void createUser(UserModel user,  BuildContext context) async {
//    await   _db.collection("Users").add(user.toJson()).whenComplete(() {
//       _message = "Saved Successfully!";
//       print(message);
//       const snackBar = SnackBar(content: Text('Saved Successfully!'),
//       backgroundColor: Color.fromARGB(10, 76, 175, 79),
//       dismissDirection: DismissDirection.down,);
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
    
//     ).catchError((error, stackTrace) {
//       _message = "Failed, Try again";
//       print(message);
//       const snackBar = SnackBar(content: Text('Failed!'),
//       backgroundColor: Color.fromARGB(10, 244, 67, 54),
//       dismissDirection: DismissDirection.down,);
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }); 
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:serv_now/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _message = "";
  String get message => _message;

  Future<void> createUser(UserModel user, BuildContext context) async {
    try {
      _message = "Saving...";
      notifyListeners();

      await _db.collection("Users").add(user.toJson());

      _message = "Saved Successfully!";
      showSuccessSnackbar(context, "Saved Successfully!");
    } catch (error) {
      _message = "Failed, Try again";
      showErrorSnackbar(context, "Failed!");
    } finally {
      notifyListeners();
    }
  }

  void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Color.fromARGB(10, 76, 175, 79),
      dismissDirection: DismissDirection.up,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.grey,
      dismissDirection: DismissDirection.up,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
