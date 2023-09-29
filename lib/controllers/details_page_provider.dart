

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:serv_now/models/service_model.dart';

class DetailsPageProvider extends ChangeNotifier {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
ServiceModel? _serviceData;
ServiceModel? get serviceData => _serviceData;

set serviceData(ServiceModel? value) {
    _serviceData = value;
    notifyListeners();
  }
}