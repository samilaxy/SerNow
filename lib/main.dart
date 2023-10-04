import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/controllers/home_provider.dart';
import 'package:serv_now/controllers/my_adverts.dart';
import 'package:serv_now/screens/auth/phone.dart';
import 'package:serv_now/screens/auth/verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:serv_now/screens/home/home.dart';
import 'package:serv_now/screens/home/my_adverts.dart';
import 'package:serv_now/screens/profile/profile_page.dart';
import 'package:serv_now/screens/profile/update_profile_screen.dart';
import 'controllers/auth_provider.dart';
import 'controllers/create_service_provider.dart';
import 'controllers/details_page_provider.dart';
import 'controllers/profile_proviver.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  AuthProvider authProvider = AuthProvider();
  // ProfileProvider proProvider = ProfileProvider();
  // proProvider.saveProfile("name", "+233249058525", "bio", "email", "img");

  bool userLoggedIn = await authProvider.loginState();

  String initialRoute = userLoggedIn ? 'home' : 'home';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
         ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
         ChangeNotifierProvider<CreateServiceProvider>(
          create: (_) => CreateServiceProvider(),
        ),
         ChangeNotifierProvider<DetailsPageProvider>(
          create: (_) => DetailsPageProvider(),
        ),
        ChangeNotifierProvider<MyAdvertsProvider>(
          create: (_) => MyAdvertsProvider(),
        ),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String
      initialRoute; // Add this line to declare the initialRoute parameter

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: initialRoute, // Use the provided initialRoute
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
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
