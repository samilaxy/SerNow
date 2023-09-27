import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/models/user_model.dart';

class HomeProvider extends ChangeNotifier {
  final List<ServiceModel> _data = [];
  String _userId = "";
  Map<String, dynamic>? profileData;
  List get data => _data;
  String get userId => _userId;
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

    final List<Future<void>> fetchUserDataTasks = [];

    // Process the documents and add fetchUserData tasks
    documents.forEach((document) {
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
        }),
      );
    });

    // Wait for all fetchUserData tasks to complete concurrently
    await Future.wait(fetchUserDataTasks);

    print('print data beloved: $_data');
    notifyListeners();
  } catch (error) {
    print("Firestore Error fetching services: $error");
  }
}

 Future<void> fetchUserData(String documentId) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(documentId).get();

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
      print("Fetched user data: $_userModel");
    } else {
      // Handle the case where the document does not exist
    }
  } catch (error) {
    print("Firestore Error fetching user data: $error");
  }
}

  Future<UserModel?> fetchUser(String documentId) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
        .collection("users") // Replace with your Firestore collection name
        .doc(documentId) // Specify the document ID you want to fetch
        .get();

    if (documentSnapshot.exists) {
      // Document exists, you can access its data
      final Map<String, dynamic> userData = documentSnapshot.data()!;
      final userModel = UserModel(
          // Print user data // Save user data using the saveContact function
          id: _userId,
          phone: userData['phone'] ?? '',
          bio: userData['bio'] ?? '',
          email: userData['email'] ?? '',
          img: userData['img'] ?? '',
          fullName: userData['name'] ?? '',
        );
      return userModel;
    } else {
      // Document does not exist
      return null;
    }
  } catch (e) {
    // Handle any errors that might occur
    print("Error fetching document: $e");
    return null;
  }
}
}
