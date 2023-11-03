import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utilities/constants.dart';

class MessageAlert extends StatelessWidget {
  String message;
  int colorInt;

   MessageAlert({super.key,
  required this.message,
  required this.colorInt
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 16),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: mainColor, width: 1),
            borderRadius: BorderRadius.circular(10),
            color: colorInt == 1 ? Colors.red : Colors.green,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message,
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                const SizedBox(width: 10),
                const Icon(
                  Icons.error_outline,
                  size: 20,
                )
              ],
            ),
          )),
    );
  }
}
