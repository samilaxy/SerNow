import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:riverpod/riverpod.dart';
import "../Utilities/constants.dart";

final nameProvider = StateProvider<String?>((ref) => null);
final emailProvider = StateProvider<String?>((ref) => null);

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   //   final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pushNamed(context, 'profile'), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tEditProfile, style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage("tProfileImage"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
                      child: const Icon(LineAwesomeIcons.camera, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("Full Name"), prefixIcon: Icon(LineAwesomeIcons.user)),
                    ),
                    const SizedBox(height: 70 - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                           label: Text("Email"), prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                    ),
                    const SizedBox(height: 70 - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text("Phone"), prefixIcon: Icon(LineAwesomeIcons.phone)),
                    ),
                    const SizedBox(height: 70 - 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon:
                        IconButton(icon: const Icon(LineAwesomeIcons.eye_slash), onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>Navigator.pushNamed(context, 'updateProfile'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text(tEditProfile, style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: "Joined",
                            style: TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "JoinedAt",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text("Delete"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}