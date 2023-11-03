import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serv_now_new/models/user_model.dart';
import 'package:serv_now_new/repository/shared_preference.dart';
import 'package:serv_now_new/utilities/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;
  int _seconds = 0;
  int get seconds => _seconds;
  static String? verificationId;
  static String? error;
  String? _contact = "";
  bool _showAlert = false;
  String _message = "";
  String? get contact => _contact;
  bool get showAlert => _showAlert;
  String get message => _message;
  String _code = "";
  String _smsCode = "";
  String get code => _code;
  String get smsCode => _smsCode;
  String _userPin = "";
  String get coduserPine => _userPin;
  UserModel? _user;
  UserModel? get user => _user;
  // User _users;
  // User get users => _users;

  set contact(String? value) {
    _contact = value;

    notifyListeners();
  }

  AuthProvider() {
    loginState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    notifyListeners();
  }
  // Update the return type to use Future<User?> for sign-in
  Future<User?> sendCodeToPhone(String number) async {
    final isInteger = int.tryParse(number);
    if (number.isEmpty || isInteger == null) {
      alertMessage("Invalid phone number");
    } else {
      Completer<User?> completer = Completer<User?>();
      // _contact = number;
      try {
        await _auth.verifyPhoneNumber(
            phoneNumber: _contact,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await _auth.signInWithCredential(credential).then(
                  (value) => {navigatorKey.currentState!.pushNamed('home')});
              _smsCode = credential.smsCode ?? '';
            },
            verificationFailed: (FirebaseAuthException e) {
              print('error: $e');
            },
            codeSent: (String verificationId, [int? resendToken]) async {
              AuthProvider.verificationId = verificationId;
              _smsCode = verificationId;
              notifyListeners();
              await navigatorKey.currentState!.pushNamed('verify');
              completer.complete(
                  null); // Complete with null when the verification code is sent
              print(
                  'Verification code sent. Verification ID: $verificationId, Resend token: $resendToken');
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              verificationId = verificationId;
            },
          //  timeout: const Duration(seconds: 60)
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
  }

  // Sign in the user using the verification code
  Future<User?> signInWithVerificationCode(String verificationCode) async {
    Completer<User?> completer = Completer<User?>();

    if (verificationCode.length < 6) {
      alertMessage("code incomplete ");
      print(_message);
    }
    if (verificationCode.length < 6) {
      alertMessage("code incorrect ");
      print(_message);
    }

    try {
      PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: AuthProvider.verificationId!,
        smsCode: verificationCode,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(_credential);
      // Save the user's phone number after verification

      _auth
          .signInWithCredential(_credential)
          .then((result) => {
                if (result != null)
                  {
                    if (_contact != null)
                      {
                        saveContact(_contact!),
                      }
                  }
              })
          .catchError((error) {
        print('verication error: $error');
      });
      // save login state
      isLogin(true);
      notifyListeners();
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
      await SharedPreferencesHelper.saveProfile(
          "", "", phoneNumber, "", "", "", false);
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
    if (!isLoggedIn) {
      getCode();
    }
    notifyListeners();
    return isLoggedIn;
  }

  Future<void> getCode() async {
    String countryCode = await UtilityClass.getCurrentLocation();
    //await Future.delayed(const Duration(seconds: 2));
    _code = countryCode.isEmpty ? "GH" : countryCode;
    notifyListeners();
  }

  Future<void> resendCode() async {
    startTimer();
    await sendCodeToPhone(_contact ?? "");
    notifyListeners();
  }

  Future alertMessage(String text) async {
    _showAlert = true;
    _message = text;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    _showAlert = false;
    notifyListeners();
  }

  _updateTimer(Timer timer) {
    _seconds++;
    if (_seconds >= 60) {
      _stopTimer();
      _seconds = 0;
    }
    notifyListeners();
  }

  startTimer() {
    // Start the timer when this function is called
    if (_seconds == 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  _stopTimer() {
    // Stop the timer when this function is called
    _timer.cancel();
  }
}
