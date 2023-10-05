
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serv_now/main.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/models/user_model.dart';
import 'package:serv_now/repository/shared_preference.dart';

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
  List get imageUrls => _imgUrls;
  String get title => _title;
  String get category => _category;
  String get price => _price;
  String get location => _location;
  String get description => _description;


set servId(String value) {
    _servId = value;
    notifyListeners();
  }


MyAdvertsProvider() {
    fetchServices();
  }


 Future<void> fetchServices() async {
     loadprofileData();
    await Future.delayed(const Duration(seconds: 0));
    print(" userId: ${_userId}");
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


    Future<void> updateService(ServiceModel service, BuildContext context) async {
    try {
     // delayUpdate();
      await _db.collection("services").doc(servId).update(service.toJson());
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
}