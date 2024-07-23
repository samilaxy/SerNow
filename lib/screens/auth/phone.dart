
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../controllers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:serv_now_new/screens/components/message_alert.dart';

import '../../utilities/constants.dart';

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
    // countryController.text = "+233";

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

    final authService = Provider.of<AuthService>(context);
    //numberController.text = authService.contact;
    return Scaffold(
       resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Container(
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
                      height: 50,
                    ),
                    Text(
                      "Welcome",
                      style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Add your number. We will send you a verification code!",
                      style: GoogleFonts.poppins(
                        fontSize: 11.0,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                        height: 90,
                        child: IntlPhoneField(
                            controller: numberController,
                            // pickerDialogStyle: ,
                            flagsButtonPadding:
                                const EdgeInsets.only(left: 20, right: 10),
                            showDropdownIcon: false,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                            ),
                            disableLengthCheck: false,
                            dropdownTextStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                            ),
                            focusNode: focusNode,
                            cursorColor: mainColor,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(100)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              labelText: "Phone",
                            ),
                            initialCountryCode: "GH", //authService.code,
                            languageCode: "en",
                            onChanged: (phone) {
                              authService.contact = phone.completeNumber;
                              // numberController.text = phone.completeNumber;
                            })),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))),
                          onPressed: () async {
                          //  await navigatorKey.currentState!.pushNamed('verify');
                            if (!authService.isLoading) {
 await authService.verifyPhone(numberController.text, context);
                          },
                          child: authService.isLoading
                            ?  const SizedBox(
                              width: 20,
                              height: 20,
                              child:  CircularProgressIndicator(
                                  color: Colors.black26),
                            ) : Text("Send Code",
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
          ),
          if (authService.showAlert)
            MessageAlert(message: authService.message, colorInt: 1)
        ],
      ),
    );
  }
}
