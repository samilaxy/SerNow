import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class UtilityClass {

static Future<String> uploadedImg(String imageName, Uint8List file) async {

 Reference ref = _storage.ref().child(imageName);
 UploadTask uploadTask = ref.putData(file);
 TaskSnapshot snapshot = await uploadTask;
 String imgUrl = await snapshot.ref.getDownloadURL();
 return imgUrl;
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