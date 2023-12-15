
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _keyContact = 'contact';

  static Future<void> saveProfile(String userId, String name, String phoneNumber, String bio, String email, String img, String role, bool isUser, List bookmarks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Create a map to represent the contact
    Map<String, dynamic> contact = {
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'email': email,
      'img': img,
       'role': role,
      'isUser': isUser,
      'bookmarks': bookmarks
    };

    // Convert the contact map to a JSON string
    String contactJson = jsonEncode(contact);

    // Save the JSON string to shared preferences
    await prefs.setString(_keyContact, contactJson);
  }

  static Future<Map<String, dynamic>?> getContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from shared preferences
    String? contactJson = prefs.getString(_keyContact);

    // If the JSON string is null, return null
    if (contactJson == null) {
      return null;
    }

    // Convert the JSON string back to a map
    Map<String, dynamic> contact = jsonDecode(contactJson);

    return contact;
  }

  static Future<void> clearContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyContact);
  }

    static Future<void> isLogin(bool isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", isLogin);
  }
  
}

