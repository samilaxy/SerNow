 
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serv_now/models/service_model.dart';

class UpdateServiceProvider extends ChangeNotifier {
   final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _message = "";
  String _title = "";
  String _category = "";
  String _price = "";
  String _location = "";
  String _description = "";
  String _userId = "";
  bool isDark = false;
  List<File> _imgs = [];
  List _imgUrls = [];
  final List<String> _dropdownOptions = [];

  String get message => _message;
  List get imageUrls => _imgUrls;
  List get imgs => _imgs;
  String get title => _title;
  String get category => _category;
  String get price => _price;
  String get location => _location;
  String get description => _description;
  String get userId => _userId;
  final ImagePicker _imgPicker = ImagePicker();
  Map<String, dynamic>? profileData;

  List get dropdownOptions => _dropdownOptions;

  UpdateServiceProvider() {
   // loadprofileData();
  }

//  Future<void> updateUserInfo(String userId, ServiceModel updatedUser, BuildContext context) async {
    
//     try {

//       await _db
//           .collection("users")
//           .doc(_userId)
//           .update(updatedUser.toJson());
//       _message = "Info updated successfully.";
//       showSuccessSnackbar(context, _message);
//     } catch (error) {
//       _message = "Update Failed, Try again.";
//        showErrorSnackbar(context, _message);
//       // Handle error as needed
//     }
//   }

}