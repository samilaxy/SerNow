import 'dart:async';
import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serv_now/models/user_model.dart';
import 'package:serv_now/repository/shared_preference.dart';
import 'package:serv_now/utilities/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AuthProvider extends ChangeNotifier {
  static String? verificationId;
  static String? error;
  String? _contact = "";
  String? get contact => _contact;
  String _code = "";
  String get code => _code;
  String _userPin = "";
  String get coduserPine => _userPin;
  UserModel? _user;
  UserModel? get user => _user;


set contact(String? value) {
    _contact = value;
    notifyListeners();
  }
  
AuthProvider() {
  loginState();
}
  // Update the return type to use Future<User?> for sign-in
  Future<User?> sendCodeToPhone(String number) async {
    Completer<User?> completer = Completer<User?>();
    _contact = number;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            completer.complete(
                userCredential.user); // Complete with the signed-in user
            print('User automatically signed in: ${userCredential.user?.uid}');
          } catch (e) {
            completer
                .complete(null); // Complete with null in case of sign-in error
            print('Error auto-signing in: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          error = e.message;
          completer.complete(
              null); 
            throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          AuthProvider.verificationId = verificationId;
          _userPin = verificationId;
          navigatorKey.currentState!.pushNamed('verify');
          completer.complete(
              null); // Complete with null when the verification code is sent
          print(
              'Verification code sent. Verification ID: $verificationId, Resend token: $resendToken');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        AuthProvider.verificationId = verificationId;
        print('Code auto-retrieval timeout. Verification ID: $verificationId');
      },
      );

      return completer.future;
    } catch (e) {
      print('An error occurred during verification: $e');
      completer
          .complete(null); // Complete with null in case of verification error
      return completer.future;
    }
  }

  // Sign in the user using the verification code
  Future<User?> signInWithVerificationCode(String verificationCode) async {
   
    Completer<User?> completer = Completer<User?>();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: AuthProvider.verificationId!,
        smsCode: verificationCode,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // Save the user's phone number after verification
      String? phoneNumber = userCredential.user?.phoneNumber;
      
      if (phoneNumber != null) {
        saveContact(phoneNumber);
      }
      // save login state
      isLogin(true);
      completer.complete(userCredential.user);
      print(
          'User signed in with verification code: ${userCredential.user?.uid}');
    } catch (e) {
      print('Error signing in with verification code: $e');
      completer.complete(null); // Complete with null in case of sign-in error
    }

    return completer.future;
  }

  // Save contact information using SharedPreferencesHelper
  Future<void> saveContact(String phoneNumber) async {
     final prefs = await SharedPreferences.getInstance();
    final savedPhoneNumber = prefs.getString('phoneNumber');
    if (savedPhoneNumber == null) {
    _user = UserModel(fullName: "fullName", phone: phoneNumber);
    await SharedPreferencesHelper.saveProfile("",phoneNumber, "","","");
    }
  }

  void isLogin(bool login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', login);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

Future<bool> loginState() async {
  getCode();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('login') ?? false;
  print("loginstatus: $isLoggedIn");
  return isLoggedIn;
}

Future<void> getCode() async {
   String countryCode = await UtilityClass.getCurrentLocation();
  _code = countryCode;
}

}
