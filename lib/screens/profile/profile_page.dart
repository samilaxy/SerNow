import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Utilities/constants.dart';
import '../../controllers/auth_provider.dart';
import '../../controllers/profile_proviver.dart';
import '../../main.dart';
import '../components/image_with_placeholder.dart';

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
    final authProvider = Provider.of<AuthProvider>(context);

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
                  style: GoogleFonts.poppins(fontSize: 18)),
              const SizedBox(height: 5),
              Text("Barber", style: GoogleFonts.poppins(fontSize: 12)),
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
                  child: Text("Edit Profile",
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white70)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 8),

              /// -- MENU
              //  ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
              //  ProfileMenuWidget(title: "User Management", icon: LineAwesomeIcons.user_check, onPress: () {}),
              Row(children: [
                Text("Bio",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 41),
                      child: Text(profileProvider.bio,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.poppins(fontSize: 14))),
                )
              ]),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 60),
                child: Divider(),
              ),
              const SizedBox(height: 5),
              Row(children: [
                Text("Phone",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(profileProvider.contact,
                        style: GoogleFonts.poppins(fontSize: 14)))
              ]),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 60),
                child: Divider(),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Text("Email",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(profileProvider.email,
                        style: GoogleFonts.poppins(fontSize: 14)))
              ]),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 40),
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
                        authProvider.isLogin(false);
                        navigatorKey.currentState!.pushNamed('myAdverts');
                      },
                      icon: const Icon(
                        LineAwesomeIcons.tags,
                        size: 20,
                      ),
                      color: Colors.grey),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("My Adverts",
                        style: GoogleFonts.poppins(
                            fontSize: 15)))
              ]),
              const SizedBox(height: 20),
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
                        authProvider.isLogin(false);
                        navigatorKey.currentState!.pushNamed('phone');
                      },
                      icon: const Icon(
                        LineAwesomeIcons.alternate_sign_out,
                        size: 20,
                      ),
                      color: Colors.grey),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Logout",
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.red)))
              ]),
            const SizedBox(height: 80),
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
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, 'home'),
          icon: Icon(LineAwesomeIcons.angle_left,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Profile",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal)),
      actions: [
        IconButton(
            onPressed: () {
              // ProfileProvider.colorMode();
            },
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                color: Theme.of(context).iconTheme.color))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
