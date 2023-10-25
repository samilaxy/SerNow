import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_provider.dart';
import '../../utilities/constants.dart';
import '../../main.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+233";

    super.initState();
  }

  @override
  void dispose() {
    countryController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    final authService = Provider.of<AuthProvider>(context);
    //numberController.text = authService.contact;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoImg,
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Welcome",
                style: GoogleFonts.poppins(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Add your number. We will send you a verification code!",
                style: GoogleFonts.poppins(
                  fontSize: 10.0,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                  height: 70,
                  child: IntlPhoneField(
                    controller: numberController,
                    focusNode: focusNode,
                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(100)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                      labelText: "Phone",
                    ),
                    initialCountryCode: authService.code,
                    languageCode: "en",
                    onChanged: (phone) {
                      authService.contact = phone.completeNumber;
                      // numberController.text = phone.completeNumber;
                    },
                    onCountryChanged: (country) {
                      print('Country changed to: ' + country.name);
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    onPressed: () async {
                      //  Navigator.pushNamed(context, 'verify');

                      if (numberController.text.isNotEmpty) {
                        String? verificationCode = (await authService
                            .sendCodeToPhone(authService.contact!)) as String?;
                        // navigatorKey.currentState!.pushNamed('verify');
                        if (verificationCode != null) {
                          // Proceed with verification using the `verificationCode`
                          print(
                              'Verification code received: $verificationCode');

                          // Call the signInWithVerificationCode method to sign in the user
                          User? user = await authService
                              .signInWithVerificationCode(verificationCode);

                          if (user != null) {
                            // The user is successfully signed in.
                            navigatorKey.currentState!.pushNamed('verify');
                            print('User signed in: ${user.uid}');
                          } else {
                            // Sign-in failed or verification code is invalid.
                            print('Failed to sign in.');
                          }
                        }
                      }
                    },
                    child: Text("Send Code",
                        style: GoogleFonts.poppins(
                          // fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ))),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
