import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:serv_now/repository/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static String? verificationId;
  static String? error;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

AuthProvider() {
  loginState();
}
  // Update the return type to use Future<User?> for sign-in
  Future<User?> sendCodeToPhone(String countryCode, String number) async {
    Completer<User?> completer = Completer<User?>();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "$countryCode$number",
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
              null); // Complete with null in case of verification failure
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          AuthProvider.verificationId = verificationId;
          completer.complete(
              null); // Complete with null when the verification code is sent
          print(
              'Verification code sent. Verification ID: $verificationId, Resend token: $resendToken');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          AuthProvider.verificationId = verificationId;
          completer.complete(
              null); // Complete with null when code auto-retrieval times out
          print(
              'Code auto-retrieval timeout. Verification ID: $verificationId');
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
    await SharedPreferencesHelper.saveProfile("",phoneNumber, "","","");
    }
  }

  void isLogin(bool login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', login);
    notifyListeners();
  }

  Future<bool> loginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    _isLoggedIn = prefs.getBool('login') ?? false;
    print("loginstatus: $_isLoggedIn");
    notifyListeners();
    return _isLoggedIn;
  }
}
