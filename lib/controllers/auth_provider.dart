import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serv_now_new/models/user_model.dart';
import 'package:serv_now_new/repository/shared_preference.dart';
import 'package:serv_now_new/utilities/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utilities/constants.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;
  int _seconds = 60;
  int get seconds => _seconds;
  bool _isLoading = false;
  bool _isVerify = false;
  String _verificationId = '';
  static String? error;
  String? _contact = "";
  bool _showAlert = false;
  String _message = "";

  bool get isVerify => _isVerify;
  bool get isLoading => _isLoading;
  String get verificationId => _verificationId;
  String? get contact => _contact;
  bool get showAlert => _showAlert;
  String get message => _message;
  String _code = "";
  final String _smsCode = "";
  String get code => _code;
  String get smsCode => _smsCode;
  final String _userPin = "";
  String get coduserPine => _userPin;
  UserModel? _user;
  UserModel? get user => _user;
  // User _users;
  // User get users => _users;

  set contact(String? value) {
    _contact = value;

    notifyListeners();
  }

  AuthService() {
    loginState();
    notifyListeners();
  }
  // Update the return type to use Future<User?> for sign-in
  // Future<User?> sendCodeToPhone(String number) async {
  //   final isInteger = int.tryParse(number);
  //   if (number.isEmpty || isInteger == null) {
  //     alertMessage("Invalid phone number");
  //   } else {
  //     Completer<User?> completer = Completer<User?>();
  //     // _contact = number;
  //     try {
  //       await _auth.verifyPhoneNumber(
  //         phoneNumber: _contact,
  //         verificationCompleted: (PhoneAuthCredential credential) async {
  //           await _auth.signInWithCredential(credential).then(
  //               (value) => {navigatorKey.currentState!.pushNamed('home')});
  //           _smsCode = credential.smsCode ?? '';
  //         },
  //         verificationFailed: (FirebaseAuthException e) {
  //           switch (e.code) {
  //             case 'invalid-phone-number':
  //               // invalid phone number
  //               _message = 'Invalid phone number!';
  //             case 'invalid-verification-code':
  //               // invalid otp entered
  //               _message = 'The entered OTP is invalid!';
  //             // handle other error codes
  //             default:
  //               _message = 'Something went wrong!';
  //             // handle error further if needed
  //           }
  //           notifyListeners();
  //         },
  //         timeout: const Duration(seconds: 60),
  //         codeSent: (String verificationId, int? resendToken) async {
  //           AuthProvider.verificationId = verificationId;
  //           _smsCode = verificationId;
  //           _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  //           notifyListeners();
  //           await navigatorKey.currentState!.pushNamed('verify');
  //           // Create a PhoneAuthCredential with the code
  //           PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //               verificationId: verificationId, smsCode: smsCode);

  //           // Sign the user in (or link) with the credential
  //           await _auth.signInWithCredential(credential);
  //         },
  //         codeAutoRetrievalTimeout: (String verificationId) {
  //           verificationId = verificationId;
  //         },
  //         //  timeout: const Duration(seconds: 60)
  //         //   codeAutoRetrievalTimeout: (String verificationId) {
  //         //   AuthProvider.verificationId = verificationId;
  //         //   print('Code auto-retrieval timeout. Verification ID: $verificationId');
  //         // },
  //       );

  //       return completer.future;
  //     } catch (e) {
  //       completer
  //           .complete(null); // Complete with null in case of verification error
  //       return completer.future;
  //     }
  //   }
  // }

  Future<void> verifyPhone(String phoneNumber, BuildContext context) async {
    final isInteger = int.tryParse(phoneNumber);
    if (phoneNumber.isEmpty || isInteger == null) {
      _message = "Invalid phone number";
      showErrorSnackbar(context, _message);
    } else {
      verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
        // Automatically sign in the user when SMS code is sent by the code auto-retrieval.
        await _auth.signInWithCredential(phoneAuthCredential);
      }

      _isLoading = true;
      notifyListeners();
      verificationFailed(FirebaseAuthException e) {
        switch (e.code) {
          case 'invalid-phone-number':
            // invalid phone number
            _message = 'Invalid phone number!';
            break;
          case 'invalid-verification-code':
            // invalid otp entered
            _message = 'The entered OTP is invalid!';
            break;
          // handle other error codes
          default:
            _message = 'Something went wrong!';
          // handle error further if needed
        }

        showErrorSnackbar(context, _message);
        _isLoading = false;
        notifyListeners();
      }

      codeSent(String verificationId, int? forceResendingToken) async {
        _verificationId = verificationId;

        startTimer();
        _isLoading = false;
        notifyListeners();
        await navigatorKey.currentState!.pushNamed('verify');
      }

      codeAutoRetrievalTimeout(String verificationId) {
        _verificationId = verificationId;
      }

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: _contact,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        );
      } catch(_) { }
    }
  }

  // Sign in the user using the verification code
  Future<void> verifyCode(String code, BuildContext context) async {
    String smsCode = code;

    final isInteger = int.tryParse(code);
    if (smsCode.isEmpty || isInteger == null || smsCode.length < 6) {
      _message = "Invalid code";
      showErrorSnackbar(context, _message);
    } else {
      _isVerify = true;
      try {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId:
              verificationId, // Use the verification ID obtained during OTP send
          smsCode: smsCode,
        );

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential);

        if (userCredential.user != null) {
          // User successfully authenticated
          // You can navigate to the next screen or perform any desired actions
          _isVerify = false;
          navigatorKey.currentState!.pushNamed('home');
          if (_contact != null) {
            saveContact(_contact!);
          }
          isLogin(true);
        }
      } catch (e) {
        // Handle exceptions, such as invalid OTP code or expired verification ID
        if (e is FirebaseAuthException && e.code == 'code-expired') {
          // Handle expired verification ID error
          _message = 'Verification code has expired. Please request a new one.';
        } else if (e is FirebaseAuthException &&
            e.code == 'invalid-verification-code') {
          // Handle invalid OTP code error
          _message = 'Code Invalid, Please try again.';
        } else {
          // Handle other exceptions
          _message = 'Something went wrong, Please try again.';
        }
        _isVerify = false;
        notifyListeners();
        showErrorSnackbar(context, _message);
      } finally {
        notifyListeners();
     
      }
    }
  }

  // Save contact information using SharedPreferencesHelper
  Future<void> saveContact(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhoneNumber = prefs.getString('phoneNumber');
    if (savedPhoneNumber == null) {
      _user = UserModel(fullName: "fullName", phone: phoneNumber,role: "", bio: '');
      await SharedPreferencesHelper.saveProfile(
          "", "", phoneNumber, "", "", "", "", false, []);
      notifyListeners();
    }
  }

  void isLogin(bool login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', login);
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

  Future<void> logOut() async {
    try {
      isLogin(false);
      bool userLoggedIn = await loginState();
      await navigatorKey.currentState!.pushNamed('onBoarding');
    } catch (_) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> getCode() async {
    String countryCode = await UtilityClass.getCurrentLocation();
    //await Future.delayed(const Duration(seconds: 2));
    _code = countryCode.isEmpty ? "GH" : countryCode;
    notifyListeners();
  }

  Future<void> resendCode(BuildContext context) async {
    if (_seconds == 0) {
      await verifyPhone(_contact ?? "", context);
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
              color: mainColor), // Show loading spinner
        );
      },
    );
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
    _seconds--;
    if (_seconds <= 0) {
      _stopTimer();
    }
    _seconds == 60;
    notifyListeners();
  }

  startTimer() {
    // Start the timer when this function is called
    _seconds = 60;
    if (_seconds == 60) {
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
