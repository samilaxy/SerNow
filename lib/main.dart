import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:serv_now/screens/auth/phone.dart';
import 'package:serv_now/screens/auth/verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:serv_now/home/home.dart';
import 'package:serv_now/home/profile_page.dart';
import 'package:serv_now/home/update_profile_screen.dart';
import 'controllers/auth_provider.dart';
import 'controllers/profile_proviver.dart';
import 'firebase_options.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    
    String initialRoute = authProvider.isLoggedIn ? 'phone' : 'home';

    return MaterialApp(
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 194, 111, 3),
        // Set the primary color of your app
        // hintColor: Colors.green, // Set the accent color of your app
      ),
      routes: {
        'phone': (context) => const MyPhone(),
        'home': (context) => const HomePage(),
        'verify': (context) => const MyVerify(),
        'profile': (context) => const ProfileScreen(),
        'update': (context) => const UpdateProfileScreen(),
      },
    );
  }
}
