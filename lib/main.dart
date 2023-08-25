
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/screens/auth/phone.dart';
import 'package:serv_now/screens/auth/verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:serv_now/screens/home/home.dart';
import 'package:serv_now/screens/profile/profile_page.dart';
import 'package:serv_now/screens/profile/update_profile_screen.dart';
import 'controllers/auth_provider.dart';
import 'controllers/profile_proviver.dart';
import 'firebase_options.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AuthProvider authProvider = AuthProvider();
  bool userLoggedIn = await authProvider.loginState();

  String initialRoute = userLoggedIn ? 'home' : 'phone';

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
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String initialRoute; // Add this line to declare the initialRoute parameter

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: initialRoute, // Use the provided initialRoute
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 194, 111, 3),
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
