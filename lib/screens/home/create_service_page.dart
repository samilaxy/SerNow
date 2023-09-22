import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utilities/constants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({Key? key}) : super(key: key);

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController desController = TextEditingController();

  String? _selectedOption;
  // Options for the dropdown menu
  final List<String> _dropdownOptions = ['Barber','Hair Dresser','Plumber', 'Fashion', 'Mechanic'];

  @override
  void dispose() {
    titleController.dispose();
    catController.dispose();
    priceController.dispose();
    countryController.dispose();
    cityController.dispose();
    areaController.dispose();
    desController.dispose();
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
              const SizedBox(height: 30),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: titleController,
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
                          label: const Text("Title*"),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField(
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                      items: _dropdownOptions.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Container(
                            width: 200, // Set the width of the container
                            child: Text(option),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          labelText: 'Category*',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          prefixIcon: Container(width: 10),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Price*"),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Country*"),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("City*"),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: areaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: const Text("Area"),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: desController,
                      maxLines: 10, // Declare a TextEditingController
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: const Text("Description*"),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add photo",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey)),
                          const SizedBox(height: 10),
                          Text("Add at least 1 - 5 photos for this category",
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "First picture - is the title picture. You can change the order of photos",
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ImageUploadField(),
                    const SizedBox(height: 20),
                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();
                          final price = priceController.text.trim();
                          final country = countryController.text.trim();
                          final city = cityController.text.trim();
                          final area = areaController.text.trim();
                          final images = [];
                          String? category = _selectedOption;
                          print('Selected Option: $category');
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
                        child: const Text("Create",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 80)
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
          icon: Icon(LineAwesomeIcons.angle_left,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Create Service",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ImageUploadField extends StatefulWidget {
  @override
  _ImageUploadFieldState createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  List<Asset> _images = [];
// Request camera and storage permissions
  Future<void> loadAssets() async {
    // Check and request permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    // Check if permissions are granted before proceeding
    if (statuses[Permission.camera]?.isGranted == true &&
        statuses[Permission.storage]?.isGranted == true) {
      List<Asset> resultList = [];
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 5, // Set the maximum number of images allowed
          enableCamera: false, // Enable the camera for capturing new images
          selectedAssets: _images,
        );
      } on Exception catch (e) {
        // Handle any errors that might occur
        print(e);
      }

      if (!mounted) return;

      setState(() {
        _images = resultList;
      });
    } else {
      // Handle the case where one or both permissions are not granted
      if (statuses[Permission.camera]?.isGranted == false) {
        // Handle camera permission not granted
      }
      if (statuses[Permission.storage]?.isGranted == false) {
        // Handle storage permission not granted
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          width: 50,
          color: Color.fromARGB(225, 174, 168, 168),
          child: IconButton(
            icon: const Icon(LineAwesomeIcons.plus),
            onPressed: () {
              loadAssets();
            },
          ),
        ),
        // ElevatedButton(
        //   onPressed: loadAssets,
        //   child: const Text("Select Images"),
        // ),
        const SizedBox(height: 10.0),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
          ),
          itemCount: _images.length,
          itemBuilder: (BuildContext context, int index) {
            Asset asset = _images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          },
        ),
      ],
    );
  }
}
