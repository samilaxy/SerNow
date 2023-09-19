import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Utilities/constants.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({Key? key}) : super(key: key);

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // -- IMAGE with ICON
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Full Name"),
                          prefixIcon: const Icon(
                            LineAwesomeIcons.user,
                            color: Colors.grey,
                          )),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Email"),
                          prefixIcon: const Icon(LineAwesomeIcons.envelope_1)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Phone"),
                          prefixIcon: const Icon(LineAwesomeIcons.phone)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: bioController,
                      maxLines: 5, // Declare a TextEditingController
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        label: const Text("Bio"),
                        prefixIcon: const Icon(LineAwesomeIcons.info_circle),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final fullName = fullNameController.text.trim();
                          final email = emailController.text.trim();
                          final phone = phoneController.text.trim();
                          final bio = bioController.text.trim();

                          //   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          // final userModel = UserModel(
                          //   fullName: fullName,
                          //   email: email,
                          //   phone: phone,
                          //   bio: bio,
                          //   img: imgUrl
                          // );
                          // profileProvider.createUser(userModel, context);
                          //  Navigator.pushNamed(context, 'profile');
                        },
                        //  },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Update",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 20)
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
                onPressed: () => Navigator.pushNamed(context, 'home'),
                icon: Icon(LineAwesomeIcons.angle_left, color: Theme.of(context).iconTheme.color)) ,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Create Service", style: GoogleFonts.poppins(textStyle: TextStyle(color: Theme.of(context).iconTheme.color), fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
