import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:serv_now_new/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/discover_model.dart';
import '../models/service_model.dart';

class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ServiceModel> _fullData = [];
  List<DiscoverModel> _data = [];
  bool _noData = false;
  bool _dataState = true;
  static String? error;
  String _message = "";
  String status = 'Pending';
  int _count = 0;
  bool _isApproveLoading = false;
  bool _isRejectLoading = false;

  ServiceModel? _serviceData;
  bool get isApproveLoading => _isApproveLoading;
  bool get isRejectLoading => _isRejectLoading;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  ServiceModel? get serviceData => _serviceData;
  String get message => _message;
  bool get dataState => _dataState;
  bool get noData => _noData;
  int get count => _count;
  List get data => _data;
  List get fullData => _fullData;

  AdminProvider() {
    fetchServices();
    notifyListeners();
  }

  Future<void> fetchServices() async {
    await Future.delayed(const Duration(seconds: 1));
    _dataState = true;

    try {
      QuerySnapshot querySnapshot = await _db
          .collection('services')
          .where('status', isEqualTo: status) // Replace with the user's ID
          .get();

      _data = []; // Reset the _data array
      _fullData = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        DiscoverModel service = DiscoverModel(
          id: document.id,
          title: data['title'] ?? '',
          price: data['price'] ?? '',
          views: data['views'] ?? '',
          img: data['imgUrls'][0] ?? '',
          status: data['status'],
          comments: data['comment'],
        );
        _data.add(service);
        _count = _data.length;
        final userId = data["userId"];
        // Create a new list for each document
        final List<Future<void>> fetchUserDataTasks = [];

        // Add a task to fetch user data concurrently
        fetchUserDataTasks.add(
          fetchUserData(userId).then((userModel) {
            final serviceCard = ServiceModel(
              id: document.id,
              userId: userId,
              title: data["title"],
              category: data["category"],
              price: data["price"],
              location: data["location"],
              description: data["description"],
              isFavorite: false,
              status: data["status"],
              views: data["views"],
              imgUrls: data["imgUrls"],
              user: _userModel,
              comments: data['comments'],
            );
            _fullData.add(serviceCard);
          }),
        );
        // Wait for all fetchUserData tasks to complete concurrently for each document
        await Future.wait(fetchUserDataTasks);
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
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchService(int index) async {
    // await Future.delayed(const Duration(seconds: 2));
    // _dataState = true;
    try {
      _serviceData = _fullData[index];

      // ignore: empty_catches
    } catch (error) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> reviewService(
      String servId, String type, String comment, BuildContext context) async {
    // await Future.delayed(const Duration(seconds: 2));
    String status = type == "reject" ? "Rejected" : "Active";

    if (type == "reject" && comment.isEmpty) {
      _message = "Please, leave comments for the provider";
      showErrorSnackbar(context, _message);
    } else {
      try {
        _isApproveLoading = type == "reject" ? true : false;
        _isRejectLoading = type == "reject" ? false : true;
        await _db
            .collection("services")
            .doc(servId)
            .update({'status': status, 'comment': comment});
        _message = "Service $status ";
        _isRejectLoading = false;
        _isApproveLoading = false;
        showSuccessSnackbar(context, _message);
        fetchServices();
      } catch (error) {
        _isRejectLoading = false;
        _isApproveLoading = false;
        _message = "Something, went wrong";
        showErrorSnackbar(context, _message);
        print(error.toString());
      } finally {
        _isRejectLoading = false;
        _isApproveLoading = false;
        notifyListeners();
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
          role: data['role'],
        );
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {
      // _dataState = false;
    } finally {
      notifyListeners();
    }
  }

  void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    );
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      dismissDirection: DismissDirection.up,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  dynamic launchTel(String? path) async {
    try {
      Uri phone = Uri(
        scheme: 'tel',
        path: path,
      );

      await launchUrl(phone);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
