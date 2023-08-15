import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serv_now/controllers/service.dart';
import '../../Utilities/constants.dart';

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
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
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
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: numberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                      Navigator.pushNamed(context, 'verify');

                      // if (numberController.text.isNotEmpty) {
                      //   Navigator.pushNamed(context, 'verify');
                      //   String? verificationCode =
                      //       (await AuthService.sendCodeToPhone(
                      //           countryController.text,
                      //           numberController.text)) as String?;

                      //   if (verificationCode != null) {
                      //     // Proceed with verification using the `verificationCode`
                      //     print(
                      //         'Verification code received: $verificationCode');

                      //     // Call the signInWithVerificationCode method to sign in the user
                      //     User? user =
                      //         await AuthService.signInWithVerificationCode(
                      //             verificationCode);

                      //     if (user != null) {
                      //       // The user is successfully signed in.
                      //       print('User signed in: ${user.uid}');
                      //     } else {
                      //       // Sign-in failed or verification code is invalid.
                      //       print('Failed to sign in.');
                      //     }
                      //   } else {
                      //     // Handle error if the verification code is not received
                      //     print('Verification code not received.');
                      //   }
                      // }
                    },
                    child: Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class CountryCodePickerWidget extends StatefulWidget {
//   @override
//   _CountryCodePickerWidgetState createState() => _CountryCodePickerWidgetState();
// }

// class _CountryCodePickerWidgetState extends State<CountryCodePickerWidget> {
//   Country _selectedCountry;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text('Select Country'),
//           trailing: _selectedCountry != null
//               ? Text('+${_selectedCountry.phoneCode}')
//               : Text('Select'),
//           onTap: _openCountryPicker,
//         ),
//       ],
//     );
//   }

//   void _openCountryPicker() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CountryPickerDialog(
//           onValuePicked: (Country country) {
//             setState(() {
//               _selectedCountry = country;
//             });
//           },
//         );
//       },
//     );
//   }
// }


