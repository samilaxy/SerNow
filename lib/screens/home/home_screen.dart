import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/controllers/details_page_provider.dart';
import 'package:serv_now/controllers/home_provider.dart';
import 'package:serv_now/screens/components/shimmer_loader.dart';

import '../../Utilities/constants.dart';
import '../components/servie_card.dart';
import 'service_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final detailsProvider = Provider.of<DetailsPageProvider>(context);

    return Scaffold(
        appBar: const CustomAppBar(),
        body: homeProvider.dataState ?
        Center(
          child:  
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: mainColor, strokeWidth: 6),
              const SizedBox(height: 10),
              Text(
                "Please wait, while services load...",
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ):
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.8,
                crossAxisSpacing: 5.0),
            padding: const EdgeInsets.all(10),
            itemCount: homeProvider.data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  detailsProvider.serviceData = homeProvider.data[index];
                  detailsProvider.fetchDiscoverServices();
                  detailsProvider.fetchRelatedServices();
                  // Navigate to the details page here, passing data[index] as a parameter
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceDetailsPage(),
                      //                    builder: (context) => ServiceDetailsPage(homeProvider.data[index]),
                    ),
                  );
                },
                child: homeProvider.dataState ? const LoadingIndicator() : ServiceCard(
                  service: homeProvider.data[index] 
                ),
              );
            }));
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                logoImg,
                width: 80,
                height: 80,
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       // ProfileProvider.colorMode();
            //     },
            //     icon: Padding(
            //       padding: const EdgeInsets.only(right: 20),
            //       child: Icon(isDark
            //           ? LineAwesomeIcons.sun
            //           : LineAwesomeIcons.horizontal_ellipsis),
            //     ))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
