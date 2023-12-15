// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../components/botton_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return 
      const BottomNarBar()
      ;
  }
}

