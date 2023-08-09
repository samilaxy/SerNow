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
      appBar: const CustomAppBar(),
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
                        child: const Image(image: AssetImage(tProfileImage))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: mainColor),
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
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          
                          borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(100)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          label  : const Text("Full Name"), prefixIcon: const Icon(LineAwesomeIcons.user,color: Colors.grey,)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                           label: const Text("Email"), prefixIcon: const Icon(LineAwesomeIcons.envelope_1)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          label: const Text("Phone"), prefixIcon: const Icon(LineAwesomeIcons.phone)),
                    ),
                    const SizedBox(height: 10),
                    // TextFormField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                    //     label: const Text("Password"),
                    //     prefixIcon: const Icon(Icons.fingerprint),
                    //     suffixIcon:
                    //     IconButton(icon: const Icon(LineAwesomeIcons.eye_slash), onPressed: () {}),
                    //   ),
                    // ),
                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, 'updateProfile'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Update", style: TextStyle(color: Colors.black)),
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
                                  text: "  May 23",
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

class CustomAppBar extends StatelessWidget  implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox( height: kToolbarHeight,
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
    
        children: [
          IconButton(onPressed: () => Navigator.pushNamed(context, 'profile') , icon: const Icon(LineAwesomeIcons.angle_left)),
          Text("Edit Profile", style: Theme.of(context).textTheme.titleSmall),
          Container() 
        ],
      ),
      ),
    );
  }
  
  @override
  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}