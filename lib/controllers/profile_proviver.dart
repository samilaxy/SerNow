import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serv_now/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repository/shared_preference.dart';
import '../Utilities/util.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _message = "";
  String _contact = "";
  String _name = "";
  String _email = "";
  String _bio = "";
  String _userId = "";
  bool isDark = false;
  Uint8List? _image;
  String _imageBase64 = "";
  String _imageUrl = "";
  
  String get imageUrl => _imageUrl;
  String get name => _name;
  String get contact => _contact;
  String get message => _message;
  String get email => _email;
  String get bio => _bio;
  String get userId => _userId;
  Uint8List? get image => _image;
  
  
  String? get imageBase64 => _imageBase64;
  Map<String, dynamic>? profileData; // Store retrieved contact information

  ProfileProvider() {
    // Automatically load contact information when the provider is created
    loadprofileData();
    
  }

  Future<void> createUser(UserModel user, BuildContext context) async {
  final fullName = user.fullName.trim();
  final email = user.email?.trim();
  final phone = user.phone.trim();

  if (fullName.isEmpty || phone.isEmpty) {
    _message = "Please fill in all fields";
    showErrorSnackbar(context, _message);
    return;
    // Exit early if any field is empty
  }

  if (email != null) {
    if (!isEmailValid(email)) {
      _message = "Invalid email format";
      showErrorSnackbar(context, _message);
      return; // Exit early if email format is invalid
    }
  }

  try {
    _message = "Updating...";
    saveProfile(
            user.fullName,
            user.phone,
            user.bio ?? '',
            user.email ?? '',
            user.img ?? '');
            
    showLoadingDialog(context); // Show loading spinner

    if (await isPhoneExists(contact)) {
      // Phone number exists, update user
      print("old user");
      updateUserInfo(contact, user, context);
    } else {
      // Phone number doesn't exist, create user
      print("new user");
      await _db.collection("users").add(user.toJson());
      _message = "Saved Successfully!";
    }

    Navigator.pop(context); // Hide loading spinner
    showSuccessSnackbar(context, _message);
  } catch (error) {
    _message = "Failed, Try again"; // Print the Firestore error
    showErrorSnackbar(context, _message);
  } finally {
    loadprofileData();
    notifyListeners();
  }
  delayLoad();
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(), // Show loading spinner
      );
    },
  );
}

  Future<void> delayLoad() async {
  await Future.delayed(Duration(seconds: 1)); // Delay for one second
  // Call the method you want to execute after the delay
  loadprofileData();
}

  Future<void> fetchUserData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("users")
               .where("phone", isEqualTo: contact)
              .get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs; 
      // Process the documents as needed
        for (var document in documents) {
        // Access document data using document.data()
        final userData = document.data();
        _userId = document.id;
        print(
            'my userId $userId'); // Print user data // Save user data using the saveContact function
        saveProfile(
            userData['name'] ?? '',
            userData['phone'] ?? '',
            userData['bio'] ?? '',
            userData['email'] ?? '',
            userData['img'] ?? '');
      }
    } catch (error) {
      print("Firestore Error1 fetch: $error");
    }
  }

  Future<void> updateUserInfo(String userId, UserModel updatedUser, BuildContext context) async {
    
    try {

      await _db
          .collection("users")
          .doc(_userId)
          .update(updatedUser.toJson());
      _message = "Info updated successfully.";
      showSuccessSnackbar(context, _message);
    } catch (error) {
      _message = "Update Failed, Try again.";
       showErrorSnackbar(context, _message);
      // Handle error as needed
    }
  }

  Future<void> saveProfile(String name, String phoneNumber, String bio,
      String email, String img) async {
    await SharedPreferencesHelper.saveProfile(
        name, phoneNumber, bio, email, img);     
  }

  Future<bool> isPhoneExists(String phoneNumber) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .where("phone", isEqualTo: phoneNumber)
            .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (error) {
    print("Firestore Error: $error");
    return false; // Return false on error or if phone number doesn't exist
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

  // Get contact information using SharedPreferencesHelper
  Future<void> loadprofileData() async {
   // fetchUserData();
    profileData = await SharedPreferencesHelper.getContact();
    if (profileData != null) {
      _name = profileData!['name'] ?? '';
      _contact = profileData!['phoneNumber'] ?? '';
      _email = profileData!['email'] ?? '';
      _bio = profileData!['bio'] ?? '';
      _imageUrl = profileData!['img'] ?? '';
      //  _image = base64Decode(_imageBase64);
    }
    print("profileData $profileData");
    fetchUserData();
    notifyListeners();
  }

  Future<void> colorMode() async {
    isDark == true ? false : true;
    notifyListeners();
  }

  // Clear contact information using SharedPreferencesHelper
  Future<void> clearContact() async {
    await SharedPreferencesHelper.clearContact();
  }

  Future<void> selectImg() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    //uploadImageToStorage(_image);
    _image = img;
    _imageBase64 = base64Encode(img);
    await uploadImageToStorage(_image);
    notifyListeners();
  }

  pickImage(ImageSource src) async {
    final ImagePicker imgPicker = ImagePicker();
    XFile? file = await imgPicker.pickImage(source: src);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  Future<void> uploadImageToStorage(Uint8List? img) async {   
    if (img != null) {
      try {
  
        _imageUrl = await UtilityClass.uploadedImg("profilImages", img);
      } catch (err) {
        _message = err.toString();
        print(_message);
      }
    }
    notifyListeners();
  }
}
