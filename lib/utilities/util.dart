
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class UtilityClass {

static Future<String> uploadedImg(String imageName, Uint8List file) async {
String uniqueFilename = "${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}.jpg";

 Reference ref = _storage.ref().child(imageName).child(uniqueFilename);
 UploadTask uploadTask = ref.putData(file);
 TaskSnapshot snapshot = await uploadTask;
 String imgUrl = await snapshot.ref.getDownloadURL();
 return imgUrl;
}

static Future<String> getCurrentLocation() async {
  String defaultCountry = '';
  try {
    // Request location permission
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Determine the country based on the user's location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String? countryCode = placemarks[0].isoCountryCode;
        defaultCountry = countryCode ?? 'US';
      }
    } else {
      print('Location permission denied');
    }
  } catch (e) {
    print('Error getting location: $e');
  }
  return defaultCountry;
}



// Future<String> saveData({
//   required String name,
//   required String bio,
//   required Uint8List file
// }) async {
//   String resp = " Some Error Occurred ";

//   try {
//     await uploadedImgToStorage("profileImages", file);
//   }
//   catch(err) {
//     resp = err.toString();
//     return resp;
//   }
// }
}