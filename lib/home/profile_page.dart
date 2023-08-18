import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Utilities/constants.dart';
import '../controllers/profile_proviver.dart';
import 'components/profile_menu_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(tProfileImage))),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 35,
                  //     height: 35,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(100),
                  //         color: mainColor),
                  //     // child: const Icon(
                  //     //   LineAwesomeIcons.alternate_pencil,
                  //     //   color: Colors.black,
                  //     //   size: 20,
                  //     // ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Text(profileProvider.name,
                  style: Theme.of(context).textTheme.headline4),
              Text("Barber", style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 10),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, 'update'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white70)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              //  ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
              //  ProfileMenuWidget(title: "User Management", icon: LineAwesomeIcons.user_check, onPress: () {}),
               Row(children: [
               
                const Text("Bio", style: TextStyle(color: Colors.grey)),
                Padding(padding: const EdgeInsets.only(left: 40),
                child: Text(profileProvider.bio, style: const TextStyle(color: Colors.black)))
                
              ]),
              const SizedBox(height: 30),
              const Divider(),
              Row(children: [
                const Text("Phone", style: TextStyle(color: Colors.grey)),
                Padding(padding: const EdgeInsets.only(left: 20),
                child: Text(profileProvider.contact, style: const TextStyle(color: Colors.black)))
              ]),
              const Divider(),
              Row(children: [
                const Text("Email", style: TextStyle(color: Colors.grey)),
                Padding(padding: const EdgeInsets.only(left: 25),
                child: Text(profileProvider.email, style: const TextStyle(color: Colors.black)))
              ]),
              const Divider(),
              const SizedBox(height: 10),
              //   ProfileMenuWidget(title: "Information", icon: LineAwesomeIcons.info, onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Navigator.pushNamed(context, 'phone');
                    // Get.defaultDialog(
                    //   title: "LOGOUT",
                    //   titleStyle: const TextStyle(fontSize: 20),
                    //   content: const Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 15.0),
                    //     child: Text("Are you sure, you want to Logout?"),
                    //   ),
                    //   confirm: Expanded(
                    //     child: ElevatedButton(
                    //       onPressed: () => AuthenticationRepository.instance.logout(),
                    //       style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                    //       child: const Text("Yes"),
                    //     ),
                    //   ),
                    //   cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, 'home'),
                icon: const Icon(LineAwesomeIcons.angle_left)),
            Text("Profile", style: Theme.of(context).textTheme.titleSmall),
            IconButton(
                onPressed: () {
               // ProfileProvider.colorMode();
                },
                icon:
                    Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
