
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/models/user_model.dart';
import 'package:serv_now/repository/shared_preference.dart';

class MyAdvertsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<DiscoverModel> _data = [];
  bool _dataState = true;
   String _userId = "";
  
  List get data => _data;
  UserModel? _userModel;
  Map<String, dynamic>? profileData;
  String get userId => _userId;
  UserModel? get userModel => _userModel;
 bool get dataState => _dataState;


MyAdvertsProvider() {
    fetchDiscoverServices();
  }


 Future<void> fetchDiscoverServices() async {
     loadprofileData();
    await Future.delayed(const Duration(seconds: 2));
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
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          img: data['imgUrls'][0] ?? '',
        );
        _data.add(service);
        if (_data.isNotEmpty) {
              print("here ${_data.length}");
               _dataState = false;
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
}