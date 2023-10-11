import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/controllers/my_adverts_provider.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';
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

  // String? _selectedOption = "Barber";
  Country? _selectedCountry;
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
    final service = Provider.of<MyAdvertsProvider>(context);
    titleController.text = service.title;
    String? selectedOption = service.category;
    priceController.text = service.price;
    countryController.text = service.country;
    cityController.text = service.city;
    areaController.text = service.area ?? '';
    descController.text = service.description;
    FocusNode focusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
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
                      value: selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                      items: _dropdownOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: SizedBox(
                            width: 100, // Set the width of the container
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
                    const SizedBox.shrink(),
                    SizedBox(
                        height: 90,
                        child: IntlPhoneField(
                          controller: countryController,
                          focusNode: focusNode,
                          cursorColor: mainColor,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            labelText: "Country*",
                          ),
                          initialCountryCode: '+233', //authService.code,
                          languageCode: "en",
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                            countryController.text = country.name;
                          },
                          showCountryFlag: true,
                        )),
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
                          label: Text("Price*", style: GoogleFonts.poppins()),
                          prefixIcon: Container(width: 10),
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text("GHS",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 12)),
                          )),
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
                          label: Text("City*", style: GoogleFonts.poppins()),
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
                          label: Text("Sub", style: GoogleFonts.poppins()),
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
                          label: Text("Description*",
                              style: GoogleFonts.poppins()),
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
                    if (service.uploading)
                      const CircularProgressIndicator(
                          color: mainColor, strokeWidth: 6),
                    SizedBox(
                      height: 120,
                      child: GridView.builder(
                          itemCount: service.imgUrls.length + 1,
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
                                          onPressed: () {
                                            service.pickImages(context);
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color:
                                                Color.fromARGB(255, 87, 84, 84),
                                          )),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.all(0),
                                    child:
                                        //  service.imgs.isNotEmpty ? Stack(children: [Image(image: service.imgs[index - 1]), IconButton(onPressed: (){service.removeImg(index - 1); }, icon: const Icon(Icons.delete_outline, color: Colors.red,))]) :
                                        Stack(
                                      children: [
                                        ImageWithPlaceholder(
                                            imageUrl:
                                                service.imgUrls[index - 1],
                                            placeholderUrl: noImg),
                                        IconButton(
                                            onPressed: () {
                                              service.removeImg(index - 1);
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
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
                          final images = service.imgUrls;
                          String? category = selectedOption;

                          final serviceModel = UpdateModel(
                            //id: uniqueId,
                            //  userId: userId,
                            title: title,
                            category: category ?? "",
                            price: price,
                            location: "$country-$city, $area",
                            description: description,
                            imgUrls: images,
                          );
                          service.isloading
                              ? null
                              : service.updateService(serviceModel, context);

                          // Navigator.pushNamed(context, 'home');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: service.isloading
                            ?  const SizedBox(
                              width: 20,
                              height: 20,
                              child:  CircularProgressIndicator(
                                  color: Colors.black26),
                            )
                            : const Text("Update",
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
