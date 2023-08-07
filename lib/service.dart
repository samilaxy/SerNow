

// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService{
//  static String? code;
//  static String? error;
//  static sendCodeToPhone(String countryCode, String number)async {
//      await FirebaseAuth.instance.verifyPhoneNumber(
//   phoneNumber:"$countryCode$number",
//   verificationCompleted: (PhoneAuthCredential credential) {
//     code = credential.smsCode;
//     print('succes is ${credential.smsCode}');
//   },
//   verificationFailed: (FirebaseAuthException e) {
//     error = e.message;
//     print('failed  ${e.message}');
//   },
//   codeSent: (String verificationId, int? resendToken) {
    
//     print('code sent is $verificationId resent token $resendToken}');
//   },
//   codeAutoRetrievalTimeout: (String verificationId) {print('autoretrieve is $verificationId');},
// );
//   }

// static bool verifySmsCode(String? enteredCode) {
//   print("code is $code pin is $enteredCode");
//   return enteredCode == code;
//   }
// }

import 'dart:async'; // Import the async library for Completer

import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   static String? code;
//   static String? error;
//   static bool isVerified = false;

//   // Update the return type to use Future<String?>
//   static Future<String?> sendCodeToPhone(String countryCode, String number) async {
//     // Create a Completer to handle the completion of the verification process
//     Completer<String?> completer = Completer<String?>();

//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: "$countryCode$number",
//         verificationCompleted: (PhoneAuthCredential credential) {
//           code = credential.smsCode;
//           print('Verification completed automatically. SMS code: ${credential.smsCode}');
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           error = e.message;
//           print('Verification failed: ${e.message}');
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           print('Verification code sent. Verification ID: $verificationId, Resend token: $resendToken');
//           // Complete the Future when the verification code is sent
//           completer.complete(null);
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           print('Code auto-retrieval timeout. Verification ID: $verificationId');
//           // Complete the Future when the code auto-retrieval times out
//           completer.complete(null);
//         },
//       );

//       // Return the Future with the code
//       return completer.future;
//     } catch (e) {
//       // Handle any exceptions that may occur during the verification process
//       print('An error occurred during verification: $e');
//       // Complete the Future with null in case of an error
//       completer.complete(null);
//       return completer.future;
//     }
//   }

//   static Future<bool> verifySmsCode(String? enteredCode) async {
//   print("code is $code pin is $enteredCode");


//   // Call the AuthService method to sign in with the verification code
//   User? user = await AuthService.signInWithVerificationCode(enteredCode!);

//   if (user != null) {
//     // Successful sign-in
//     print('User signed in: ${user.uid}');
//     isVerified = true;
//     // Navigate to the next screen or perform other actions
//   } else {
//     // Sign-in failed
//     isVerified = false;
//     print('Sign-in failed.');
//     // Display an error message or handle the error
//   }
//   return isVerified;
//   }

//   static Future<User?> signInWithVerificationCode(String verificationCode) async {
//     try {
//       // Create a PhoneAuthCredential using the verification code
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationCode,
//         smsCode: verificationCode,
//       );

//       // Sign the user in with the provided credential
//       UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

//       // Return the signed-in user
//       return authResult.user;
//     } catch (e) {
//       // Handle any sign-in errors
//       print('An error occurred during sign-in: $e');
//       return null;
//     }
//   }
// }


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
