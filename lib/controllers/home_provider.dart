import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/models/user_model.dart';

class HomeProvider extends ChangeNotifier {
  final List<ServiceModel> _data = [];
  bool _dataState = false;
  Map<String, dynamic>? profileData;
  List get data => _data;
  bool get userId => _dataState;
  UserModel? _userModel;
  
  UserModel? get userModel => _userModel;


  HomeProvider() {
    fetchAllServices();
  }

 Future<void> fetchAllServices() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("services").get();


    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;
// if (querySnapshot.exists) {

    final List<Future<void>> fetchUserDataTasks = [];

    // Process the documents and add fetchUserData tasks
    for (var document in documents) {
      final serviceData = document.data();
      final userId = serviceData["userId"];

      // Add a task to fetch user data concurrently
      fetchUserDataTasks.add(
        fetchUserData(userId).then((userModel) {
          final serviceCard = ServiceModel(
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
          notifyListeners();
        }),
      );
    //}

    // Wait for all fetchUserData tasks to complete concurrently
    await Future.wait(fetchUserDataTasks);
 }
    notifyListeners();
  } catch (error) {
    if (_data.isEmpty) {
    _dataState = false;
    }
  }
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
