import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_proviver.dart';
import '../../main.dart';
import '../../screens/home/boomark_page.dart';
import '../../screens/home/create_service_page.dart';
import '../../screens/home/my_adverts.dart';
import '../../utilities/constants.dart';
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

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  void onItemTapped(int tab, Widget screen) {
    setState(() {
      currentTab = tab;
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    return Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          Text(
                            "Home",
                            style: TextStyle(
                                color:
                                    currentTab == 0 ? mainColor : Colors.grey,
                                fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        onItemTapped(1, const HomeScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineAwesomeIcons.search,
                              color: currentTab == 1 ? mainColor : Colors.grey,
                            ),
                            Text(
                              "Search",
                              style: TextStyle(
                                  color:
                                      currentTab == 1 ? mainColor : Colors.grey,
                                  fontSize: 8),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        // minWidth: 40,
                        onPressed: () {
                          String route =
                              profile.isUser ? "createService" : "update";
                          navigatorKey.currentState!.pushNamed(route);
                        },
                        child: Container(
                          //clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            color: mainColor,
                          ),
                          height: 55,
                          width: 55,
                          child: const Icon(
                            LineAwesomeIcons.plus,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        onItemTapped(2, const BookmarkPage());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineAwesomeIcons.bookmark,
                            color: currentTab == 2 ? mainColor : Colors.grey,
                          ),
                          Text(
                            "Bookmarks",
                            style: TextStyle(
                                color:
                                    currentTab == 2 ? mainColor : Colors.grey,
                                fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          Text(
                            "Profile",
                            style: TextStyle(
                                color:
                                    currentTab == 3 ? mainColor : Colors.grey,
                                fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
