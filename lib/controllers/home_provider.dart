import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ServiceModel> _data = [];
  List<ServiceModel> _bookmarkData = [];
  bool _dataState = true;
  String _category = "";
  bool _noData = false;
  bool _noFiltaData = false;
  bool _isBook = true;
  Map<String, dynamic>? profileData;
  List get data => _data;
  bool get noData => _noData;
  bool get noFiltaData => _noFiltaData;
  bool get isBook => _isBook;
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
    print(_category);
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

  Future<void> fetchBookmarkServices() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('isFavorite', isEqualTo: true) // Replace with the user's ID
          .get();

// if (querySnapshot.exists) {
      _bookmarkData = [];
      final List<Future<void>> fetchUserDataTasks = [];

      // Process the documents and add fetchUserData tasks

      for (var document in querySnapshot.docs) {
        final serviceData = document.data() as Map<String, dynamic>;
        ;
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
            _bookmarkData.add(serviceCard);
            notifyListeners();
          }),
        );
        //}

        // Wait for all fetchUserData tasks to complete concurrently
        await Future.wait(fetchUserDataTasks);
        notifyListeners();

        if (_bookmarkData.isNotEmpty) {
          _isBook = false; // Data is available
          _noData = false;
        } else {
          _isBook = false; // No data available
          _noData = true;
        }
      }
    } catch (error) {
      if (_data.isEmpty) {
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
}
