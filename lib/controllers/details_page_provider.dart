import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/models/service_model.dart';

class DetailsPageProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ServiceModel? _serviceData;
  DiscoverModel? _discoverData;
  List<DiscoverModel> _discover = [];

  ServiceModel? get serviceData => _serviceData;
  DiscoverModel? get discoverData => _discoverData;
  List get discover => _discover;

  set serviceData(ServiceModel? value) {
    _serviceData = value;
    notifyListeners();
  }

  DetailsPageProvider() {
    //fetchDiscoverServices();
  }
  
  Future<void> fetchDiscoverServices() async {
    await Future.delayed(const Duration(seconds: 2));
    print(" userId: ${_serviceData?.userId}");
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('userId', isEqualTo: _serviceData?.userId) // Replace with the user's ID
          .get();

      //if (querySnapshot.exists) {
        //reset discovered items array
          _discover = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DiscoverModel service = DiscoverModel(
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          img: data['img'] ?? '',
        );
        _discover.add(service);
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
