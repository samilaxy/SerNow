
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/controllers/create_service_provider.dart';
import 'package:serv_now/controllers/update_service_provider.dart';
import '../../Utilities/constants.dart';
import '../../models/service_model.dart';

class UpdateServicePage extends StatefulWidget {
  const UpdateServicePage({Key? key}) : super(key: key);

  @override
  State<UpdateServicePage> createState() => _UpdateServicePageState();
}

class _UpdateServicePageState extends State<UpdateServicePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? _selectedOption;
  // Options for the dropdown menu
  final List<String> _dropdownOptions = [
    'Barber',
    'Hair Dresser',
    'Plumber',
    'Fashion',
    'Mechanic',
    "Home Service",
    "Health & Fitness",
    "Others"
  ];

  @override
  void dispose() {
    titleController.dispose();
    catController.dispose();
    priceController.dispose();
    countryController.dispose();
    cityController.dispose();
    areaController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<CreateServiceProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: Text("Title*", style: GoogleFonts.poppins()),
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
                          child: SizedBox(
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
                          label:  Text("Price*", style: GoogleFonts.poppins()),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: countryController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: Text("Country*", style: GoogleFonts.poppins()),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: cityController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label:  Text("City*", style: GoogleFonts.poppins()),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: areaController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: Text("Sub",style: GoogleFonts.poppins()),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: descController,
                      maxLines: 10, // Declare a TextEditingController
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label:  Text("Description*",style: GoogleFonts.poppins()),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 120,
                      child: GridView.builder(
                          itemCount: serviceProvider.imgs.length + 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 1.1,
                                  crossAxisSpacing: 8.0),
                          itemBuilder: ((context, index) {
                            return index == 0
                                ? Center(
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: Colors.grey,
                                      child: IconButton(
                                          onPressed:() { serviceProvider.pickImages(context); } ,
                                          icon: const Icon(Icons.add)),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(serviceProvider
                                                .imgs[index - 1]),
                                                fit: BoxFit.cover)),
                                  );
                          })),
                    ),
                    const SizedBox(height: 20),
                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                         // String uniqueId = serviceProvider.generateUniqueId();
                         // final userId = serviceProvider.userId;
                          final title = titleController.text.trim();
                          final price = priceController.text.trim();
                          final country = countryController.text.trim();
                          final city = cityController.text.trim();
                          final area = areaController.text.trim();
                          final description = descController.text.trim();
                          final images = serviceProvider.imageUrls;
                          String? category = _selectedOption;

                          final serviceModel = ServiceModel(
                            //id: uniqueId,
                          //  userId: userId,
                            title: title,
                            category: category ?? "",
                            price: price,
                            location: "$country-$city, $area",
                            description: description,
                            isFavorite: false,
                            imgUrls: images,
                            status: false,
                          );
                          serviceProvider.updateService(serviceModel, context);
                           // Navigator.pushNamed(context, 'home');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Update",
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
          onPressed: () => Navigator.pushNamed(context, 'myAdverts'),
          icon: Icon(LineAwesomeIcons.angle_left,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Update Service",
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
