import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serv_now/main.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/models/user_model.dart';
import 'package:serv_now/repository/shared_preference.dart';
import 'package:serv_now/utilities/util.dart';

class MyAdvertsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<DiscoverModel> _data = [];
  bool _dataState = true;
  bool _noData = false;
  String _userId = "";
  String _servId = "";
  String _message = "";
  String _title = "";
  String _category = "";
  String _price = "";
  String _location = "";
  String _country = "";
  String _city = "";
  String? _area = "";
  String _description = "";

  List _imgUrls = [];

  List get data => _data;
  UserModel? _userModel;
  Map<String, dynamic>? profileData;
  String get userId => _userId;
  String get servId => _servId;
  UserModel? get userModel => _userModel;
  bool get dataState => _dataState;
  bool get noData => _noData;
  String get message => _message;
  List get imgUrls => _imgUrls;
  String get title => _title;
  String get category => _category;
  String get price => _price;
  String get location => _location;
  String get country => _country;
  String get city => _city;
  String? get area => _area;
  String get description => _description;
  final ImagePicker _imgPicker = ImagePicker();

  set servId(String value) {
    _servId = value;
    notifyListeners();
  }

  MyAdvertsProvider() {
    print('myAdvert.servId2: ${_servId}');
    fetchServices();
    // fetchService();
  }

  Future<void> fetchServices() async {
    loadprofileData();
    print('myAdvert.servId4: ${_servId}');
    await Future.delayed(const Duration(seconds: 1));
    print("userId: ${_userId}");
    _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('userId', isEqualTo: _userId) // Replace with the user's ID
          .get();

      //reset discovered items array
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DiscoverModel service = DiscoverModel(
          id: data['id'],
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          img: data['imgUrls'][0] ?? '',
          status: data['status'],
        );
        _data.add(service);
        if (_data.isNotEmpty) {
          print("here ${_data.length}");
          _dataState = false;
        } else {
          _noData = true;
        }
      }
    } catch (error) {
      // _dataState = false;
    }
    notifyListeners();
  }

  Future<void> loadprofileData() async {
    profileData = await SharedPreferencesHelper.getContact();
    if (profileData != null) {
      _userId = profileData!['userId'] ?? '';
    }
    print("profileData $profileData");
    notifyListeners();
  }

  Future<void> fetchService(String servId) async {
    // await Future.delayed(const Duration(seconds: 2));
    // _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('id', isEqualTo: servId) // Replace with the user's ID
          .get();

      //reset discovered items array
      //  _discover = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        _servId = data['id'] ?? '';
        _title = data['title'] ?? '';
        _category = data['category'] ?? '';
        _price = data['price'] ?? '';
        _imgUrls = data['imgUrls'] ?? [];
        _location = data['location'] ?? '';
        _description = data['description'] ?? '';
        // Split the inputString by '-'
        List<String> splitParts = _location.split('-');
        // Extract the country (the first part)
        _country = splitParts[0].trim();
        // Split the second part (city, sub) by ','
        List<String> citySubParts = splitParts[1].split(',');
        // Extract the city (the first part of citySubParts)
        _city = citySubParts[0].trim();

        List<String> subParts = citySubParts[1].split('.');
        // Extract the sub (the second part of citySubParts)
        _area = subParts[0].trim();
      }
    } catch (error) {
      // _dataState = false;
    }
    notifyListeners();
  }

  Future<void> updateService(ServiceModel serv, BuildContext context) async {
    _title = serv.title.trim();
    _category = serv.category.trim();
    _price = serv.price.trim();
    _location = serv.location.trim();
    _description = serv.description.trim();

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
    if (imgUrls.isEmpty) {
      _message = "Upload atleast 1 photo for this service";
      showErrorSnackbar(context, _message);
      return;
      // Exit early if any field is empty
    }
    _message = "Wait...";

    try {
      // delayUpdate();
      await Future.delayed(const Duration(seconds: 2));
      await _db.collection("services").doc(servId).update(serv.toJson());
      _message = "Service updated successfully.";
      showSuccessSnackbar(context, _message);
      navigatorKey.currentState!.pushNamed('myAdverts');
    } catch (error) {
      _message = "Update Failed, Try again.";
      showErrorSnackbar(context, _message);
      // Handle error as needed
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

  Future<void> pickImages(BuildContext context) async {
    _imgUrls = [];
    final List<XFile> pickedImgs = await _imgPicker.pickMultiImage();
    for (var img in pickedImgs) {
      _imgUrls.add(File(img.path));
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
    if (_imgUrls.isNotEmpty) {
      try {
        final List<Future<String>> uploadFutures = _imgUrls.map((img) async {
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
}
