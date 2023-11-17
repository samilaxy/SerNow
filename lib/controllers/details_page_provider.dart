import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/discover_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../models/bookmark_model.dart';
import 'home_provider.dart';

class DetailsPageProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ServiceModel? _serviceData;
  DiscoverModel? _discoverData;
  String _serId = '';
  List<DiscoverModel> _discover = [];
  List<ServiceModel> _related = [];
  bool _dataState = true;
  UserModel? _userModel;
  HomeProvider homeProvider = HomeProvider();

  UserModel? get userModel => _userModel;
  ServiceModel? get serviceData => _serviceData;
  DiscoverModel? get discoverData => _discoverData;
  List get discover => _discover;
  String get serId => _serId;
  List get related => _related;

  bool get dataState => _dataState;

  set serviceData(ServiceModel? value) {
    _serviceData = value;
    notifyListeners();
  }

  DetailsPageProvider() {
    //fetchDiscoverServices();
    // fetchRelatedServices();
  }

  Future<void> fetchDiscoverServices() async {
    await Future.delayed(const Duration(seconds: 2));
    print(" userId: ${_serviceData?.userId}");
    _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('userId',
              isEqualTo: _serviceData?.userId) // Replace with the user's ID
          .get();

      //reset discovered items array
      _discover = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DiscoverModel service = DiscoverModel(
          id: data['id'],
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          img: data['imgUrls'][0] ?? '',
          status: data['status'],
        );
        _discover.add(service);
        if (_discover.isNotEmpty) {
          _dataState = false;
        }
      }
    } catch (error) {
      _dataState = false;
    }
    notifyListeners();
  }

  Future<void> fetchRelatedServices() async {
    await Future.delayed(const Duration(seconds: 3));
    _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('category',
              isEqualTo: _serviceData?.category) // Replace with the user's ID
          .get();

      //if (querySnapshot.exists) {
      //reset discovered items array
      final List<Future<void>> fetchUserDataTasks = [];
      _related = [];

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
            _related.add(service);
            if (_related.isNotEmpty) {
              _dataState = true;
            }
          }),
        );
      }
    } catch (error) {
      _dataState = false;
    }
    notifyListeners();
  }

  Future<void> fetchService(int index) async {
    // await Future.delayed(const Duration(seconds: 2));
    // _dataState = true;
    _serId = discover[index].id;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('id', isEqualTo: _serId) // Replace with the user's ID
          .get();

      //reset discovered items array
      //  _discover = [];
      // if (querySnapshot.exists) {}
      final List<Future<void>> fetchUserDataTasks = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
        notifyListeners();
      }
      // ignore: empty_catches
    } catch (error) {}

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
    if (homeProvider.bookmarkIds.contains(servId)) {
      homeProvider.bookmarkIds.remove(servId);
    } else {
      homeProvider.bookmarkIds.add(servId);
    }
    notifyListeners();

    try {
      await _db
          .collection("users")
          .doc(userId)
          .update({'bookmarks': homeProvider.bookmarkIds});

      homeProvider.fetchBookmarkServices();
      homeProvider.fetchAllServices();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
    notifyListeners();
  }
}
