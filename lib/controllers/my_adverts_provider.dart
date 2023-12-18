import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';
import '../../models/discover_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../../repository/shared_preference.dart';
import '../../utilities/constants.dart';
import '../../utilities/util.dart';

class MyAdvertsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<DiscoverModel> _data = [];
  bool _dataState = true;
  bool _noData = false;
  bool _setStatus = false;
  bool _uploading = false;
  bool _isloading = false;
  bool _isInternet = false;
  String _userId = "";
  String _servId = "";
  Color color = Colors.blue;
  String _docId = "";
  String _message = "";
  String _title = "";
  String? _category;
  String? _status = "Active";
  String _price = "";
  String _location = "";
  String _country = "";
  String _city = "";
  String? _area = "";
  String _description = "";
  List<File> _imgs = [];
  List _imgUrls = [];

  bool get setStatus => _setStatus;
  List get data => _data;
  List get imgs => _imgs;
  UserModel? _userModel;
  Map<String, dynamic>? profileData;
  String get userId => _userId;
  String get servId => _servId;
  String get docId => _docId;
  UserModel? get userModel => _userModel;
  bool get dataState => _dataState;
  bool get noData => _noData;
  bool get uploading => _uploading;
  bool get isloading => _isloading;
  bool get isInternet => _isInternet;
  String get message => _message;
  List get imgUrls => _imgUrls;
  String get title => _title;
  String? get category => _category;
  String? get status => _status;
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
    fetchServices();
  }

  Future<void> fetchServices() async {
    loadprofileData();
    await Future.delayed(const Duration(seconds: 1));
    _dataState = true;

    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('userId', isEqualTo: _userId) // Replace with the user's ID
          .get();

      _data = []; // Reset the _data array

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DiscoverModel service = DiscoverModel(
          id: document.id,
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          views: data['views'] ?? '',
          img: data['imgUrls'][0] ?? '',
          status: data['status'],
          comments: data['comments'],
        );
        _data.add(service);
      }

      if (_data.isNotEmpty) {
        _dataState = false; // Data is available
        _noData = false;
      } else {
        _dataState = false; // No data available
        _noData = true;
      }
    } catch (error) {
      // Handle errors here
      _dataState = false;
      _noData = true;
    }

    notifyListeners();
  }

  Future<void> loadprofileData() async {
    profileData = await SharedPreferencesHelper.getContact();
    if (profileData != null) {
      _userId = profileData!['userId'] ?? '';
    }
    notifyListeners();
  }

  Future<void> fetchService(String servId, BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    // _dataState = true;
    _message = "Please wait...";
    showSuccessSnackbar(context, _message);
    try {
      final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('services').doc(servId).get();

      //reset discovered items array
      //  _discover = [];
      // if (querySnapshot.exists) {}
      if (querySnapshot.exists && querySnapshot.data() != null) {
        Map<String, dynamic> data =
            querySnapshot.data() as Map<String, dynamic>;

        _docId = querySnapshot.id;
        _servId = data['id'] ?? '';
        _title = data['title'] ?? '';
        _category = data['category'] ?? '';
        _price = data['price'] ?? '';
        _imgUrls = data['imgUrls'] ?? [];
        _location = data['location'] ?? '';
        _description = data['description'] ?? '';
       
        _status = data['status'] ?? '';
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
        _isInternet = true;
        if (_status == "Rejected" || _status == "Pending") {
          _setStatus = true;
        } else {
          _setStatus = false;
        }
      } else {
        _message = "Something went wrong, Please check your internet!!";
        showErrorSnackbar(context, _message);
      }
    } catch (error) {
      _isInternet = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateService(UpdateModel serv, BuildContext context) async {
    _title = serv.title.trim();
    _category = serv.category.trim();
    _price = serv.price.trim();
    _location = serv.location.trim();
    _description = serv.description.trim();

    if (_title.isEmpty ||
        _category!.isEmpty ||
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
    //  showLoadingDialog(context);
    _isloading = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _db.collection("services").doc(_docId).update(serv.toJson());
      await Future.delayed(const Duration(seconds: 2));
      _isloading = false;
      _message = "Service updated successfully.";
      fetchServices();
      showSuccessSnackbar(context, _message);

      await navigatorKey.currentState!.pushNamed('myAdverts');
    } catch (error) {
      _isloading = false;
      _message = "Update Failed, Try again.";
      print(' code message : $error');
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
      duration: const Duration(seconds: 1),
      dismissDirection: DismissDirection.up,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      // dismissDirection: DismissDirection.endToStart,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
              color: mainColor), // Show loading spinner
        );
      },
    );
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      _imgs = [];
      final List<XFile> pickedImgs = await _imgPicker.pickMultiImage();
      for (var img in pickedImgs) {
        _imgs.add(File(img.path));
        notifyListeners();
      }
      // Upload images in the background using microtask
      Future.microtask(() async {
        await uploadImageToStorage(context);
        notifyListeners();
        // Optionally, you can show a completion message or perform other actions when the upload is done.
        // For example, you can show a snackbar:
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Images uploaded successfully')),
        // );
      });
    } catch (e) {
      _message = e.toString();
      showErrorSnackbar(context, _message);
    } finally {
      notifyListeners();
    }
  }

  Future<void> uploadImageToStorage(BuildContext context) async {
    if (_imgs.isNotEmpty) {
      _uploading = true;
      try {
        final List<Future<String>> uploadFutures = _imgs.map((img) async {
          final fileBytes = await img.readAsBytes(); // Read file contents
          return UtilityClass.uploadedImg("serviceImgs", fileBytes);
        }).toList();
        _imgUrls += await Future.wait(uploadFutures);
        _uploading = false;
        notifyListeners();
      } catch (e) {
        _message = e.toString();
        showErrorSnackbar(context, _message);
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> deleteService(String servId, BuildContext context) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference originalCollection =
          FirebaseFirestore.instance.collection('services');
      DocumentReference originalDocument = originalCollection.doc(servId);

      // Read data from the original document
      DocumentSnapshot snapshot = await originalDocument.get();
      Map<String, dynamic> deletedData =
          snapshot.data() as Map<String, dynamic>;

      // Get a reference to the new Firestore collection
      CollectionReference archiveCollection =
          FirebaseFirestore.instance.collection('archived_services');

      // Use the reference to write the data to the new collection
      await archiveCollection.add(deletedData);

      // Use the reference to delete the original document
      await originalDocument.delete();

      _message = "Service deleted and archived successfully.";
      fetchServices();
      notifyListeners();
      showSuccessSnackbar(context, _message);
    } catch (e) {
      _message = 'Error deleting service ';
      showErrorSnackbar(context, _message);
      notifyListeners();
      // showErrorSnackbar(context, _message);
    } finally {
      notifyListeners();
    }
  }

  void removeImg(int index) {
    _imgUrls.removeAt(index);
    notifyListeners();
    _imgs.removeAt(index);
    notifyListeners();
  }

  dynamic setColor(String status) {
    switch (status) {
      case "Pending":
        color = Colors.orange;
        break;
      case "Active":
        color = Colors.green;
        break;
      case "In-Active":
        color = Colors.blue;
        break;
      case "Rejected":
        color = Colors.red;
        break;
    }
    return color;
  }
}
