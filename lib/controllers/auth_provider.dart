import 'dart:async';
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
  notifyListeners();
}
  // Update the return type to use Future<User?> for sign-in
  Future<User?> sendCodeToPhone(String number) async {
    Completer<User?> completer = Completer<User?>();
    _contact = number;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
         _code = credential.smsCode ?? '';
        },
        verificationFailed: (FirebaseAuthException e) {
        },
        codeSent: (String verificationId, int? resendToken) async {
          AuthProvider.verificationId = verificationId;
          _userPin = verificationId;
          
          notifyListeners();
          await navigatorKey.currentState!.pushNamed('verify');
          completer.complete(
              null); // Complete with null when the verification code is sent
          print(
              'Verification code sent. Verification ID: $verificationId, Resend token: $resendToken');
        }, codeAutoRetrievalTimeout: (String verificationId) {  },
      //   codeAutoRetrievalTimeout: (String verificationId) {
      //   AuthProvider.verificationId = verificationId;
      //   print('Code auto-retrieval timeout. Verification ID: $verificationId');
      // },
      );

      return completer.future;
    } catch (e) {
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
      notifyListeners();
      if (phoneNumber != null) {
        saveContact(phoneNumber);
      }
      // save login state
      isLogin(true);
      completer.complete(userCredential.user);
    } catch (e) {
      completer.complete(null); // Complete with null in case of sign-in error
    }

    return completer.future;
  }

  // Save contact information using SharedPreferencesHelper
  Future<void> saveContact(String phoneNumber) async {
     final prefs = await SharedPreferences.getInstance();
    final savedPhoneNumber = prefs.getString('phoneNumber');
    if (savedPhoneNumber == null) {
    _user = UserModel(fullName: "fullName", phone: phoneNumber, bio: '');
    await SharedPreferencesHelper.saveProfile("","",phoneNumber, "","","", false);
    notifyListeners();
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
 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('login') ?? false;
   if (!isLoggedIn) {getCode();}
  notifyListeners();
  return isLoggedIn;
}

Future<void> getCode() async {
   String countryCode = await UtilityClass.getCurrentLocation();
  //await Future.delayed(const Duration(seconds: 2));
  _code = countryCode;
  notifyListeners();
}

}
