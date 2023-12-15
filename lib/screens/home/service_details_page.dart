import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/details_page_provider.dart';
import '../../controllers/home_provider.dart';
import '../../models/service_model.dart';
import '../../screens/components/discover_card.dart';
import '../../screens/components/image_slider.dart';
import '../../screens/components/image_with_placeholder.dart';
import '../../screens/components/servie_card.dart';
import '../../screens/components/shimmer_loader.dart';
import '../../screens/home/zoom_imageview.dart';
import '../../utilities/constants.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({super.key});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final detailsProvider = Provider.of<DetailsPageProvider>(context);
    ServiceModel? serviceData = detailsProvider.serviceData;
    String currency = "Ghs ";
    return Scaffold(
      appBar: CustomAppBar(serviceData?.id ?? "", serviceData?.user?.id ?? ""),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                color: Colors.grey,
                height: 220,
                width: double.maxFinite,
                child: MyImageSlider(imageUrls: serviceData?.imgUrls ?? [])),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ZoomImageView(
                                          imageUrl:
                                              serviceData?.user?.img ?? "",
                                          placeholderUrl: tProfileImage),
                                    ));
                              },
                              child: Container(
                                  color: Colors.grey,
                                  child: ImageWithPlaceholder(
                                      imageUrl: serviceData?.user?.img ?? "",
                                      placeholderUrl: tProfileImage)),
                            ))),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(serviceData?.user?.fullName ?? "",
                                maxLines: 1,
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Text(serviceData?.category ?? "",
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
                          child: Text("$currency${serviceData?.price}",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.normal)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 0),
                          child: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(serviceData?.location ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 1),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: SizedBox(
                // color: Colors.amber,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey)),
                    Text(serviceData?.title ?? "",
                        style: GoogleFonts.poppins(fontSize: 18)),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text("Category",
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.grey)),
                                ),
                                Text(serviceData?.category ?? "",
                                    style: GoogleFonts.poppins(fontSize: 16))
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Contact",
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.grey)),
                                GestureDetector(
                                  onTap: () {
                                    detailsProvider
                                        .launchTel(serviceData?.user!.phone);
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                          size: 20,
                                          weight: 5,
                                          Icons.phone,
                                          color: Colors.green),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(serviceData?.user!.phone ?? "",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.green)),
                                    ],
                                  ),
                                )
                              ])
                        ]),
                    const SizedBox(height: 30),
                    Text("Description",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(serviceData?.description ?? "",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(fontSize: 14)),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1.5),
                    const SizedBox(height: 20),
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
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Center(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: detailsProvider.discover.length,
                itemBuilder: (BuildContext context, int index) {
                  return detailsProvider.dataState
                      ? GestureDetector(
                          onTap: () {
                            detailsProvider.fetchService(index);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServiceDetailsPage(),
                              ),
                            );
                          },
                          child: DiscoverCard(
                              service: detailsProvider.discover[index]))
                      : const SizedBox(
                          height: 200,
                          width: 160,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: LoadingIndicator(),
                          ));
                },
              )),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Related services",
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "These are similar services offered by other providers",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    ]),
              ),
            ),
            MyGridview(detailsProvider: detailsProvider),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class MyGridview extends StatelessWidget {
  const MyGridview({
    super.key,
    required this.detailsProvider,
  });

  final DetailsPageProvider detailsProvider;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: detailsProvider.related.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              detailsProvider.serviceData = detailsProvider.related[index];
              detailsProvider.fetchDiscoverServices();
              detailsProvider.fetchRelatedServices();
              // Navigate to the details page here, passing data[index] as a parameter
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceDetailsPage(),
                ),
              );
            },
            child:
                //detailsProvider.dataState ? const LoadingIndicator() :
                ServiceCard(service: detailsProvider.related[index]),
          );
        });
  }
}

// ignore: must_be_immutable
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String userId;
  String servId;
  CustomAppBar(
    //this.isFavorite,
    this.servId,
    this.userId, {
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late bool isFavorite;
  @override
  void initState() {
    isFavorite = Provider.of<HomeProvider>(context, listen: false)
        .bookmarkIds
        .contains(widget.servId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider =
        Provider.of<DetailsPageProvider>(context, listen: true);
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);

    return SafeArea(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).iconTheme.color),
            ),
            IconButton(
              onPressed: () {
                detailsProvider.bookmarkService(widget.servId);
                setState(() {
                  isFavorite = !isFavorite;
                  homeProvider.fetchAllServices();
                });
              },
              icon: Icon(
                size: 20,
                Icons.bookmark,
                color: isFavorite ? mainColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
