
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class UtilityClass {

static Future<String> uploadedImg(String imageName, Uint8List file) async {
  String uniqueFilename = "${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}.jpg";
  Reference ref = FirebaseStorage.instance.ref().child(imageName).child(uniqueFilename);
  UploadTask uploadTask = ref.putData(file);

  try {
    await uploadTask;
    String imgUrl = await ref.getDownloadURL();
    return imgUrl;
  } catch (e) {
    throw FirebaseImageUploadException("Image upload failed");
  }
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
    } 
  } catch (_) {
  }
  return defaultCountry;
}


  // static Future<void> bookmarkService(String? servId, bool isFavorite) async {
  // bool isBookmark = !isFavorite;
  // BookmarkModel bookmark = BookmarkModel(isFavorite: isBookmark);
    
  //   try {
      
  //    // await Future.delayed(const Duration(seconds: 01));
  //     await _db.collection("services").doc(servId).update(bookmark.toJson());
      
  //   } catch (error) {
  //     print(error.toString());
  //   }

  // }

  // static Future<void> bookmarkService(String servId, String userId, bool isFavorite) async {
  // bool isBookmark = !isFavorite;
  // BookmarkModel bookmark = BookmarkModel(isFavorite: isBookmark, userId: userId, servId: servId);
    
  //   try {
      
  //    // await Future.delayed(const Duration(seconds: 01));
  //     await _db.collection("services").doc(servId).update(bookmark.toJson());
      
  //   } catch (error) {
  //     print(error.toString());
  //   }

  // }
}

class FirebaseImageUploadException implements Exception {
  final String message;

  FirebaseImageUploadException(this.message);
}

