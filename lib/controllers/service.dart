

import 'dart:async'; // Import the async library for Completer

import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  static String? verificationId;
  static String? error;

  // Update the return type to use Future<User?> for sign-in
  static Future<User?> sendCodeToPhone(String countryCode, String number) async {
    Completer<User?> completer = Completer<User?>();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "$countryCode$number",
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
            completer.complete(userCredential.user); // Complete with the signed-in user
            print('User automatically signed in: ${userCredential.user?.uid}');
          } catch (e) {
            completer.complete(null); // Complete with null in case of sign-in error
            print('Error auto-signing in: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          error = e.message;
          completer.complete(null); // Complete with null in case of verification failure
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          AuthService.verificationId = verificationId;
          completer.complete(null); // Complete with null when the verification code is sent
          print('Verification code sent. Verification ID: $verificationId, Resend token: $resendToken');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          AuthService.verificationId = verificationId;
          completer.complete(null); // Complete with null when code auto-retrieval times out
          print('Code auto-retrieval timeout. Verification ID: $verificationId');
        },
      );

      return completer.future;
    } catch (e) {
      print('An error occurred during verification: $e');
      completer.complete(null); // Complete with null in case of verification error
      return completer.future;
    } 
  }

  // Sign in the user using the verification code
  static Future<User?> signInWithVerificationCode(String verificationCode) async {
    Completer<User?> completer = Completer<User?>();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: AuthService.verificationId!,
        smsCode: verificationCode,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      completer.complete(userCredential.user); // Complete with the signed-in user
      print('User signed in with verification code: ${userCredential.user?.uid}');
    } catch (e) {
      print('Error signing in with verification code: $e');
      completer.complete(null); // Complete with null in case of sign-in error
    }

    return completer.future;
  }
}
