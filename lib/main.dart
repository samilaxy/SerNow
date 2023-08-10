import 'package:flutter/material.dart';


import 'package:serv_now/screens/auth/phone.dart';
import 'package:serv_now/screens/auth/verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:serv_now/home/home.dart';
import 'package:serv_now/home/profile_page.dart';
import 'package:serv_now/home/update_profile_screen.dart';
import 'firebase_options.dart';

// ...

void main()async {

await WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    initialRoute: 'phone',
    debugShowCheckedModeBanner: false,
     theme: ThemeData(
        primaryColor:const Color.fromARGB(255, 194, 111, 3), // Set the primary color of your app
       // hintColor: Colors.green, // Set the accent color of your app
      ),
    routes: {
      'phone': (context) => const MyPhone(),
      'home': (context) => const HomePage(),
      'verify': (context) => const MyVerify(),
      'profile': (context) => const ProfileScreen(),
      'update': (context) => const UpdateProfileScreen()
    },
  ));
}

