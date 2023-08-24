import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Utilities/constants.dart';
import '../controllers/auth_provider.dart';
import '../controllers/profile_proviver.dart';
import 'components/image_with_placeholder.dart';
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Uint8List? image = profileProvider.image;
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
                    width: 130,
                    height: 130,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(tProfileImage))),
                  ),
                  image != null
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 2, // Set the border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(image),
                          ),
                        )
                      : SizedBox(
                          width: 130,
                          height: 130,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: mainColor, // Set the border color
                                width: 1, // Set the border width
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ImageWithPlaceholder(
                                imageUrl: profileProvider.imageUrl,
                                placeholderUrl: tProfileImage,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              Text(profileProvider.name,
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 5),
              Text("Barber", style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 8),

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
              const SizedBox(height: 8),

              /// -- MENU
              //  ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
              //  ProfileMenuWidget(title: "User Management", icon: LineAwesomeIcons.user_check, onPress: () {}),
              Row(children: [
                const Text("Bio", style: TextStyle(color: Colors.grey)),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 41),
                      child: Text(profileProvider.bio,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16))),
                )
              ]),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 60),
                child: Divider(),
              ),
              const SizedBox(height: 5),
              Row(children: [
                const Text("Phone", style: TextStyle(color: Colors.grey)),
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(profileProvider.contact,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)))
              ]),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 60),
                child: Divider(),
              ),
              const SizedBox(height: 8),
              Row(children: [
                const Text("Email", style: TextStyle(color: Colors.grey)),
                Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(profileProvider.email,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)))
              ]),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 30),
              Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: IconButton(
                      onPressed: () {
                        print("Logout");
                        authProvider.logout();
                        Navigator.pushNamed(context, 'phone');
                      },
                      icon: const Icon(
                        LineAwesomeIcons.alternate_sign_out,
                        size: 20,
                      ),
                      color: Colors.grey),
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Logout",
                        style: TextStyle(color: Colors.red, fontSize: 16)))
              ]),
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
