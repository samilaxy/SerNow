import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Uint8List? _image;
  String _imageBase64 = "";
  List<File> _imgs = [];
  List _imgUrls = [];

  String get message => _message;
  List get imageUrls => _imgUrls;
  List get imgs => _imgs;
  String get title => _title;
  String get category => _category;
  String get price => _price;
  String get location => _location;
  String get description => _description;
  String get userId => _userId;
  Uint8List? get image => _image;
  final MultiImagePicker imgPicker = MultiImagePicker();
  final ImagePicker _imgPicker = ImagePicker();

  Future<void> createService(ServiceModel serv, BuildContext context) async {
    final title = serv.title.trim();
    final category = serv.category.trim();
    final price = serv.price.trim();
    final location = serv.location.trim();
    final description = serv.description.trim();
    print(serv.imgUrls);

    if (title.isEmpty ||
        category.isEmpty ||
        price.isEmpty ||
        location.isEmpty ||
        description.isEmpty) {
      _message = "Please fill in all fields";
      showErrorSnackbar(context, _message);
      return;
      // Exit early if any field is empty
    }
    if (imageUrls == []) {
      _message = "Upload atleast 1 photo for this service";
      showErrorSnackbar(context, _message);
      return;
      // Exit early if any field is empty
    }
    _message = "Wait...";

    showLoadingDialog(context); // Show loading spinner

    try {
      await Future.delayed(const Duration(seconds: 1));
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

  Future<void> delayLoad() async {
    await Future.delayed(Duration(seconds: 1)); // Delay for one second
    // Call the method you want to execute after the delay
    // loadprofileData();
  }
Future<void> pickImages() async {
  final List<XFile> pickedImgs = await _imgPicker.pickMultiImage();
  if (pickedImgs != null) {
    for (var e in pickedImgs) {
      _imgs.add(File(e.path));
      notifyListeners();
    }
    print(_imgs.length);
  }
  notifyListeners();
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
