

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
 static String? code;
 static String? error;
 static sendCodeToPhone(String countryCode, String number)async {
     await FirebaseAuth.instance.verifyPhoneNumber(
  phoneNumber:"$countryCode$number",
  verificationCompleted: (PhoneAuthCredential credential) {
    code = credential.smsCode;
    print('succes is ${credential.smsCode}');
  },
  verificationFailed: (FirebaseAuthException e) {
    error = e.message;
    print('failed  ${e.message}');
  },
  codeSent: (String verificationId, int? resendToken) {
    
    print('code sent is $verificationId resent token $resendToken}');
  },
  codeAutoRetrievalTimeout: (String verificationId) {print('autoretrieve is $verificationId');},
);
  }

static bool verifySmsCode(String? enteredCode) {
  print("code is $code pin is $enteredCode");
  return enteredCode==code;
}
}