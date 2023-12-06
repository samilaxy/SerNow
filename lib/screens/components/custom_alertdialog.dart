import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final BuildContext context;
  final Function onOkPressed;
  final String title;
  final String content;

  const CustomAlertDialog({super.key, 
    required this.context,
    required this.onOkPressed,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoAlertDialog();
    } else {
      return _buildMaterialAlertDialog();
    }
  }

  Widget _buildCupertinoAlertDialog() {

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(); // Close the alert dialog
          },
          child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.red)),
        ),
        CupertinoDialogAction(
          onPressed: () {
              onOkPressed();              
            Navigator.of(context).pop(); // Close the alert dialog
          },
          child: Text('OK', style: GoogleFonts.poppins(color: Colors.green)),
        ),
      ],
    );
  }

  Widget _buildMaterialAlertDialog() {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the alert dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onOkPressed();
            Navigator.of(context).pop(); // Close the alert dialog
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
