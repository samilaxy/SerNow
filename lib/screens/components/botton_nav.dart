import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:serv_now/screens/home/create_service_page.dart';
import 'package:serv_now/screens/home/my_adverts.dart';
import 'package:serv_now/utilities/constants.dart';

import '../home/Home_screen.dart';
import '../profile/profile_page.dart';

class BottomNarBar extends StatefulWidget {
  const BottomNarBar({Key? key}) : super(key: key);

  @override
  State<BottomNarBar> createState() => _BottomNarBarState();
}

class _BottomNarBarState extends State<BottomNarBar> {
  int currentTab = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const MyAdverts(),
    const ProfileScreen(),
    const CreateServicePage(),
  ];

  final PageStorageBucket bucket =  PageStorageBucket();
  Widget currentScreen = const HomeScreen();
 
  void onItemTapped(int tab, Widget screen) {
    setState(() {
      currentTab = tab;
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(  
      bucket: bucket,
      child: currentScreen,
      ),
      floatingActionButton:
          FloatingActionButton(
          onPressed: () { onItemTapped(0, const CreateServicePage());},
          backgroundColor: mainColor,
          child: const Icon(LineAwesomeIcons.plus),),
          resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget> [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                     onItemTapped(0, const HomeScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineAwesomeIcons.home,
                          color: currentTab == 0 ? mainColor : Colors.grey,
                        ),
                        Text("Home", 
                        style: TextStyle(color: currentTab == 0 ? mainColor : Colors.grey , fontSize: 8),)
                      ],
                    ),
                  ),
                ],
              ),
               Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                     onItemTapped(1, const HomeScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineAwesomeIcons.search,
                          color: currentTab == 1 ? mainColor : Colors.grey,
                        ),
                        Text("Search", 
                        style: TextStyle(color: currentTab == 1 ? mainColor : Colors.grey, fontSize: 8),)
                      ],
                    ),
                  ),
                 
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                     onItemTapped(2, const MyAdverts());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineAwesomeIcons.bookmark,
                          color: currentTab == 2 ? mainColor : Colors.grey,
                        ),
                        Text("Bookmarks", 
                        style: TextStyle(color: currentTab == 2 ? mainColor : Colors.grey , fontSize: 8),)
                      ],
                    ),
                  ),
                ],
              ),
               Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                     onItemTapped(3, const ProfileScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineAwesomeIcons.user_tag,
                          color: currentTab == 3 ? mainColor : Colors.grey,
                        ),
                        Text("Profile", 
                        style: TextStyle(color: currentTab == 3 ? mainColor : Colors.grey, fontSize: 8),)
                      ],
                    ),
                  ),
                 
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}

