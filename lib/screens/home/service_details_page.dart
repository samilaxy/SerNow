import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/controllers/details_page_provider.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/screens/components/image_slider.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';
import 'package:serv_now/utilities/constants.dart';

class ServiceDetailsPage extends StatelessWidget {
  //ServiceModel serviceData;

  const ServiceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final detailsProvider = Provider.of<DetailsPageProvider>(context);
    ServiceModel? serviceData = detailsProvider.serviceData;
    String currency = "\$";
    return Scaffold(
      appBar: CustomAppBar(serviceData!.isFavorite),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey,
                    height: 200,
                    width: double.maxFinite,
                    child: MyImageSlider(imageUrls: serviceData.imgUrls)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    color: Colors.grey,
                                    child: ImageWithPlaceholder(
                                        imageUrl: serviceData.user?.img ?? "",
                                        placeholderUrl: tProfileImage)))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(serviceData.user?.fullName ?? "",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(fontSize: 15)),
                                Text(serviceData.category,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 25,
                              child: Text("$currency${serviceData.price}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 0),
                              child: SizedBox(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Text(serviceData.location,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey))),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Icon(size: 12, Icons.location_on),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: SizedBox(
                    // color: Colors.amber,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ttle",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey)),
                        Text(serviceData.title,
                            style: GoogleFonts.poppins(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Description",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey)),
                        Text(serviceData.description),
                        const SizedBox(height: 20),
                        const Divider(thickness: 2),
                        const SizedBox(height: 10),
                        Text("Discover more Services",
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text("These are other services offered by the provider",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.amberAccent,
                  height: 200,
                  width: double.infinity,
                  child: const Center(child: Text("Under construction")),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Related services",
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                                 Text("Thess are other services offered by the provider",
                        textAlign: TextAlign.start,
                        style:
                            GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
               
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool isFavorite;
   CustomAppBar(
    this.isFavorite, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, 'home'),
                icon: const Icon(LineAwesomeIcons.angle_left)),
            // Text("Profile", style: Theme.of(context).textTheme.titleSmall),
            IconButton(
                onPressed: () {
                  isFavorite = !isFavorite;
                  // setState();
                  // ProfileProvider.colorMode();
                  print(isFavorite);
                },
                icon: Icon(
                    size: 20,
                    Icons.bookmark,
                    color: isFavorite ? mainColor : Colors.grey))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
