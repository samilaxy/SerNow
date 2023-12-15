import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/create_service_provider.dart';
import '../../utilities/constants.dart';
import '../../models/service_model.dart';
import 'package:country_picker/country_picker.dart';

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
    final serviceProvider = Provider.of<CreateServiceProvider>(context);
    priceController.text = "";
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

                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 16, left: 45, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(100)),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text("Category*",
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 15)),
                          value: _selectedOption,
                          elevation: 16,
                          //  isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedOption = newValue;
                            });
                          },
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Theme.of(context).iconTheme.color),
                          items: _dropdownOptions.map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: SizedBox(
                                //width: 20, // Set the width of the container
                                child: Text(option),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
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
                          label: Text("Price*", style: GoogleFonts.poppins()),
                          prefixIcon: Container(width: 10)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey,
                      onTap: () {
                        countryPicker(context);
                      },
                      controller: countryController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                          label: Text("Country*",
                              style: GoogleFonts.poppins(color: Colors.grey)),
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
                          Expanded(
                            child: Text(
                                "First picture - is the title picture. You can change the order of photos",
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.grey)),
                          ),
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
                                          onPressed: () {
                                            serviceProvider.pickImages(context);
                                          },
                                          icon: const Icon(Icons.add,
                                              color: Color.fromARGB(
                                                  255, 87, 84, 84))),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.all(0),
                                    // decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //         image: FileImage(serviceProvider
                                    //             .imgs[index - 1]),
                                    //             fit: BoxFit.cover)),
                                    child: Stack(children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      serviceProvider
                                                          .imgs[index - 1]),
                                                  fit: BoxFit.cover))),
                                      IconButton(
                                          onPressed: () {
                                            serviceProvider
                                                .removeImg(index - 1);
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ))
                                    ]),
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
                          //  String uniqueId = serviceProvider.generateUniqueId();
                          final userId = serviceProvider.userId;
                          final title = titleController.text.trim();
                          final price = priceController.text.trim();
                          final country = countryController.text.trim();
                          final city = cityController.text.trim();
                          final area = areaController.text.trim();
                          final description = descController.text.trim();
                          final images = serviceProvider.imageUrls;
                          String? category = _selectedOption;

                          final serviceModel = ServiceModel(
                            userId: userId,
                            title: title,
                            category: category ?? "",
                            price: price,
                            location: "$country-$city, $area",
                            description: description,
                            isFavorite: false,
                            imgUrls: images,
                            status: "Pending",
                            views: 0,
                            comments: '',
                          );

                          serviceProvider.isloading
                              ? null
                              : serviceProvider.createService(
                                  serviceModel, context);
                          // Navigator.pushNamed(context, 'home');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: serviceProvider.isloading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.black26),
                              )
                            : const Text("Create",
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

  void countryPicker(BuildContext context) {
    return showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      showPhoneCode: false,
      onSelect: (Country country) => countryController.text = country.name,
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
          icon: Icon(Icons.arrow_back_ios_rounded,
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
