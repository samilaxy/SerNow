import 'package:flutter/material.dart';
import 'package:serv_now_new/utilities/constants.dart';

class LunchScreen extends StatelessWidget {
  const LunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Image.asset(logoImg),
        height: 50,
        width: 50)
    );
  }
}