import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/models/user_model.dart';

class DetailsPageProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ServiceModel? _serviceData;
  DiscoverModel? _discoverData;
  List<DiscoverModel> _discover = [];
  List<ServiceModel> _related = [];
  bool _dataState = true;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;
  ServiceModel? get serviceData => _serviceData;
  DiscoverModel? get discoverData => _discoverData;
  List get discover => _discover;
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
          .where('userId', isEqualTo: _serviceData?.userId) // Replace with the user's ID
          .get();


        //reset discovered items array
          _discover = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DiscoverModel service = DiscoverModel(
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          img: data['imgUrls'][0] ?? '',
          status: data['status'],
        );
        _discover.add(service);
        if (_discover.isNotEmpty) {
              print("here ${_discover.length}");
               _dataState = false;
            }
      }

    } catch (error) {
      // _dataState = false;
    }
    notifyListeners();
  }
  
  Future<void> fetchRelatedServices() async {
    await Future.delayed(const Duration(seconds: 3));
    print("category: ${_serviceData?.category}");
    _dataState = true;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('category', isEqualTo: _serviceData?.category) // Replace with the user's ID
          .get();

      //if (querySnapshot.exists) {
        //reset discovered items array
          _related = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> serviceData = document.data() as Map<String, dynamic>;
        final userId = serviceData["userId"];
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
              print("here ${_related.length}");
               _dataState = true;
            }
      }

      

      print(" jkvdk: ${_discover.length}");
      // } else {
      //   // Handle the case where the document does not exist
      // }
    } catch (error) {
      // _dataState = false;
    }
    notifyListeners();
  }
  
}
