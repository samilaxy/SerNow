import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../models/bookmark_model.dart';
import '../repository/shared_preference.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ServiceModel> _data = [];
  ServiceModel? _serviceData;
  List<ServiceModel> _bookmarkData = [];
  bool _dataState = true;
  String _category = "";
  String _userId = "";
  bool _noData = false;
  bool _noFiltaData = false;
  bool _isBook = true;
  Map<String, dynamic>? profileData;
  ServiceModel? get serviceData => _serviceData;
  List get data => _data;
  bool get noData => _noData;
  bool get noFiltaData => _noFiltaData;
  bool get isBook => _isBook;
  String get userId => _userId;
  String get category => _category;
  List get bookmarkData => _bookmarkData;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;
  bool get dataState => _dataState;
  HomeProvider() {
    fetchAllServices();
    fetchBookmarkServices();
  }

  Future<void> fetchAllServices() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("services").get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;
// if (querySnapshot.exists) {

      final List<Future<void>> fetchUserDataTasks = [];
      _data = [];
      // Process the documents and add fetchUserData tasks
      for (var document in documents) {
        final serviceData = document.data();
        final userId = serviceData["userId"];

        // Add a task to fetch user data concurrently
        fetchUserDataTasks.add(
          fetchUserData(userId).then((userModel) {
            final serviceCard = ServiceModel(
              id: document.id,
              userId: userId,
              title: serviceData["title"],
              category: serviceData["category"],
              price: serviceData["price"],
              location: serviceData["location"],
              description: serviceData["description"],
              isFavorite: serviceData["isFavorite"],
              status: serviceData["status"],
              imgUrls: serviceData["imgUrls"],
              user: _userModel,
            );

            _data.add(serviceCard);

            if (_data.isNotEmpty) {
              _dataState = false;
              notifyListeners();
              print('_dataState: $_dataState');
            }
          }),
        );
        //}

        // Wait for all fetchUserData tasks to complete concurrently
        await Future.wait(fetchUserDataTasks);
        notifyListeners();
      }
    } catch (error) {
      if (_data.isEmpty) {
        _dataState = true;
      }
    }
    notifyListeners();
  }

  Future<void> filtersServices(int index) async {
    // await Future.delayed(const Duration(seconds: 3));
    //_dataState = true;
    _category = "";
    switch (index) {
      case 1:
        _category = "Barber";
        break;
      case 2:
        _category = "Hair Dresser";
        break;
      case 3:
        _category = "Plumber";
        break;
      case 4:
        _category = "Fashion";
        break;
      case 5:
        _category = "Mechanic";
        break;
      case 6:
        _category = "Home Service";
        break;
      case 7:
        _category = "Health & Fitness";
        break;
      case 8:
        _category = "Others";
        break;
      default:
        _category = "";
    }

    await Future.delayed(const Duration(seconds: 1));
    try {
      if (_category.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collection('services')
            .where('category',
                isEqualTo: _category) // Replace with the user's ID
            .get();

        //if (querySnapshot.exists) {
        //reset discovered items array
        final List<Future<void>> fetchUserDataTasks = [];
        _data = [];

        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> serviceData =
              document.data() as Map<String, dynamic>;
          final userId = serviceData["userId"];

          fetchUserDataTasks.add(
            fetchUserData(userId).then((userModel) {
              final service = ServiceModel(
                userId: userId,
                title: serviceData["title"],
                category: serviceData["category"],
                price: serviceData["price"],
                location: serviceData["location"],
                description: serviceData["description"],
                isFavorite: serviceData["isFavorite"],
                status: serviceData["status"],
                imgUrls: serviceData["imgUrls"],
                user: _userModel,
              );
              _data.add(service);
            }),
          );
          if (_data.isNotEmpty) {
            _dataState = false;
            _noFiltaData = false;
          } else {
            print("no1 data");
            _dataState = false;
            _noFiltaData = true;
          }
        }
      } else {
        fetchAllServices();
      }
    } catch (error) {
      _dataState = false;
    }
    notifyListeners();
  }

  Future<void> loadprofileData() async {
    profileData = await SharedPreferencesHelper.getContact();
    if (profileData != null) {
      _userId = profileData!['userId'] ?? '';
      notifyListeners();
    }
  }

  Future<void> fetchBookmarkServices() async {
    loadprofileData();
    await Future.delayed(const Duration(seconds: 1));
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('bookmarks')
          .where('userId', isEqualTo: _userId) // Replace with the user's ID
          .get();

      _bookmarkData = [];
      final List<Future<void>> fetchServiceDataTasks = [];

      for (var document in querySnapshot.docs) {
        final serviceData = document.data() as Map<String, dynamic>;
        final servId = serviceData["servId"];

        // Fetch the service data for the bookmarked service
        final serviceModel = fetchService(servId);

        // Add a task to fetch service data concurrently
        fetchServiceDataTasks.add(serviceModel.then((serviceCard) {
          _bookmarkData.add(serviceCard!);
          notifyListeners();
        }));
      }
      await Future.delayed(const Duration(seconds: 2));
      // Wait for all fetchServiceData tasks to complete concurrently
      await Future.wait(fetchServiceDataTasks);
      notifyListeners();

      if (_bookmarkData.isNotEmpty) {
        _isBook = false; // Data is available
        _noData = false;
      } else {
        _isBook = false; // No data available
        _noData = true;
      }
    } catch (error) {
      if (_bookmarkData.isEmpty) {
        _isBook = true;
        _noData = false;
      }
    }
    notifyListeners();
  }

  Future<void> fetchUserData(String documentId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(documentId)
              .get();

      if (documentSnapshot.exists) {
        final Map<String, dynamic> data = documentSnapshot.data()!;
        _userModel = UserModel(
          id: documentId,
          phone: data['phone'] ?? '',
          bio: data['bio'] ?? '',
          email: data['email'] ?? '',
          img: data['img'] ?? '',
          fullName: data['name'] ?? '',
        );
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {
      _dataState = false;
    }
    notifyListeners();
  }

  Future<void> bookmarkService(String? servId, String? userId) async {
    final existingBookmarkQuery = await _db
        .collection("bookmarks")
        .where("userId", isEqualTo: userId)
        .where("servId", isEqualTo: servId)
        .get();

    if (existingBookmarkQuery.docs.isEmpty) {
      // No existing bookmark found, add a new bookmark
      BookmarkModel bookmark = BookmarkModel(userId: userId, servId: servId);
      try {
        await _db.collection("bookmarks").add(bookmark.toJson());
        notifyListeners();
      } catch (error) {
        print(error.toString());
      }
    } else {
      // An existing bookmark found, remove it
      final existingBookmarkDoc = existingBookmarkQuery.docs.first;
      try {
        await _db.collection("bookmarks").doc(existingBookmarkDoc.id).delete();
        notifyListeners();
      } catch (error) {
        print(error.toString());
      }
    }
  }

  Future<ServiceModel?> fetchService(String servId) async {
    // await Future.delayed(const Duration(seconds: 2));
    // _dataState = true;
    try {
      final DocumentSnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('services')
          .doc(servId) // Replace with the user's ID
          .get();

 print('here... service $servId');
      //reset discovered items array
      //  _discover = [];
      // if (querySnapshot.exists) {}
      final List<Future<void>> fetchUserDataTasks = [];

      Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
      final userId = data["userId"];
      fetchUserDataTasks.add(
        fetchUserData(userId).then((userModel) {
          final service = ServiceModel(
            userId: userId,
            title: data["title"],
            category: data["category"],
            price: data["price"],
            location: data["location"],
            description: data["description"],
            isFavorite: data["isFavorite"],
            status: data["status"],
            imgUrls: data["imgUrls"],
            user: _userModel,
          );
          _serviceData = service;
          notifyListeners();
        }),
      );
      await Future.wait(fetchUserDataTasks);
      notifyListeners();
      print('here... service $serviceData');
      // ignore: empty_catches
    } catch (error) {}

    notifyListeners();
    return _serviceData;
  }
}
