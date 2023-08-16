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
import '../repository/shared_preference.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _message = "";
  String contact = "";
  String name = "";
  String email = "";
  String bio = "";
  String get message => _message;
  Map<String, dynamic>? profileData; // Store retrieved contact information

  ProfileProvider() {
   // Automatically load contact information when the provider is created
    fetchUserData();
    loadprofileData(); 
  }

  Future<void> createUser(UserModel user, BuildContext context) async {
    final fullName = user.fullName.trim();
    final email = user.email.trim();
    final phone = user.phone.trim();

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty) {
      _message = "Please fill in all fields";
      showErrorSnackbar(context, _message);
      return; // Exit early if any field is empty
    }

    if (!isEmailValid(email)) {
      _message = "Invalid email format";
      showErrorSnackbar(context, _message);
      return; // Exit early if email format is invalid
    }

    try {
      _message = "Saving...";
      notifyListeners();

      await _db.collection("Users").add(user.toJson());

      _message = "Saved Successfully!";
      showSuccessSnackbar(context, _message);
    } catch (error) {
      _message = "Failed, Try again";
      print("Firestore Error: $error"); // Print the Firestore error
      showErrorSnackbar(context, _message);
    } finally {
      notifyListeners();
    }
  }

  bool isEmailValid(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      dismissDirection: DismissDirection.up,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
     // dismissDirection: DismissDirection.endToStart,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Save contact information using SharedPreferencesHelper
  Future<void> saveProfile(String name, String phoneNumber, String bio, String email) async {
    await SharedPreferencesHelper.saveProfile(name, phoneNumber, bio, email);
  }

  // Get contact information using SharedPreferencesHelper
  Future<void> loadprofileData() async {
    profileData = await SharedPreferencesHelper.getContact();
    if (profileData != null) {
      name = profileData!['name'] ?? '';
      contact = profileData!['phoneNumber'] ?? '';
      email = profileData!['email'] ?? '';
      bio = profileData!['`bio'] ?? '';
    }
    notifyListeners();
  }

  Future<void> fetchUserData() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("Users").get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;

    // Process the documents as needed
    for (var document in documents) {
      // Access document data using document.data()
      final userData = document.data();
      print('my data $userData'); // Print user data // Save user data using the saveContact function
      
      saveProfile(
        userData['name'] ?? '',
        userData['phoneNumber'] ?? '',
        userData['bio']?? '',
        userData['email']?? '',
      );

    }
  } catch (error) {
    print("Firestore Error: $error");
  }
}


  // Clear contact information using SharedPreferencesHelper
  Future<void> clearContact() async {
    await SharedPreferencesHelper.clearContact();
  }
}
