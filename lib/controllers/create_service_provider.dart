import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serv_now/repository/shared_preference.dart';
import 'package:uuid/uuid.dart';
import '../Utilities/util.dart';
import '../models/service_model.dart';

class CreateServiceProvider extends ChangeNotifier {
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

  CreateServiceProvider() {
    loadprofileData();
  }

  Future<void> createService(ServiceModel serv, BuildContext context) async {
    _title = serv.title.trim();
    _category = serv.category.trim();
    _price = serv.price.trim();
    _location = serv.location.trim();
    _description = serv.description.trim();
    print(serv.imgUrls);

    if (_title.isEmpty ||
        _category.isEmpty ||
        _price.isEmpty ||
        _location.isEmpty ||
        _description.isEmpty) {
      _message = "Please fill in all fields";
      showErrorSnackbar(context, _message);
      return;
      // Exit early if any field is empty
    }
    if (imageUrls.isEmpty) {
      _message = "Upload atleast 1 photo for this service";
      showErrorSnackbar(context, _message);
      return;
      // Exit early if any field is empty
    }
    _message = "Wait...";

    //showLoadingDialog(context); // Show loading spinner

    try {
      delayUpdate();
      await _db.collection("services").add(serv.toJson());

      _message = "Created Successfully!";
      Navigator.pop(context);
      showSuccessSnackbar(context, _message);
    } catch (error) {
      _message = "Something went wrong, Try again!";
      showErrorSnackbar(context, _message);
      // Handle error as needed
    } finally {
      notifyListeners();
    }
  }

  String generateUniqueId() {
    const uuid = Uuid();
    return uuid
        .v4(); // Generates a random UUID (e.g., "6c84fb90-12c4-11e1-840d-7b25c5ee775a")
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

  Future<void> loadprofileData() async {
    profileData = await SharedPreferencesHelper.getContact();
    if (profileData != null) {
      _userId = profileData!['userId'] ?? '';
    }
    print("profileData $profileData");
    notifyListeners();
  }

  Future<void> delayUpdate() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for one second
    // Call the method you want to execute after the delay
    // loadprofileData();
  }

  Future<void> pickImages(BuildContext context) async {
    _imgs = [];
    final List<XFile> pickedImgs = await _imgPicker.pickMultiImage();
    for (var img in pickedImgs) {
      _imgs.add(File(img.path));
      notifyListeners();
    }
    // Upload images in the background using microtask
    Future.microtask(() async {
      await uploadImageToStorage();
      // Optionally, you can show a completion message or perform other actions when the upload is done.
      // For example, you can show a snackbar:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Images uploaded successfully')),
      // );
    });
  }

  Future<void> uploadImageToStorage() async {
    if (_imgs.isNotEmpty) {
      try {
        final List<Future<String>> uploadFutures = _imgs.map((img) async {
          final fileBytes = await img.readAsBytes(); // Read file contents
          return UtilityClass.uploadedImg("serviceImgs", fileBytes);
        }).toList();

        _imgUrls = await Future.wait(uploadFutures);

        print("urls: $_imgUrls");
      } catch (err) {
        _message = err.toString();
        print(_message);
      }
    }
  }

// Future<void> retrieveLostData() async {
//   final List<LostData> lostData = await MultiImagePicker.getLostData();

//   for (LostData data in lostData) {
//     if (data.isEmpty) {
//       continue;
//     }

//     if (data.file != null) {
//       // Handle the lost image data, for example:
//       final File lostImageFile = File(data.file.path);
//       _imgs.add(lostImageFile);
//     } else {
//       // Handle other lost data types, if necessary
//       print('Lost data: ${data.exception}');
//     }
//   }

//   // Notify listeners after handling lost data
//   notifyListeners();
// }
}
