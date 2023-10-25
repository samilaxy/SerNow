import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/details_page_provider.dart';
import '../../controllers/home_provider.dart';
import '../../main.dart';
import '../../screens/components/servie_card.dart';
import '../../screens/components/shimmer_loader.dart';
import '../../screens/home/service_details_page.dart';
import '../../utilities/constants.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final detailsProvider = Provider.of<DetailsPageProvider>(context);

    return Scaffold(
        appBar: const CustomAppBar(),
        body: Stack(children: [
          if (homeProvider.isBook)
            Center(
              child: Text(
                "No service bookmarked yet",
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          homeProvider.noData
              ? SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                          color: mainColor, strokeWidth: 6),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Please wait, while services load...",
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.77,
                          crossAxisSpacing: 10.0),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: homeProvider.bookmarkData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        detailsProvider.serviceData =
                            homeProvider.bookmarkData[index];
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
                      child: homeProvider.isBook
                          ? const LoadingIndicator()
                          : Flexible(
                              child: ServiceCard(
                                  service: homeProvider.bookmarkData[index]),
                            ),
                    );
                  }),
        ]));
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () => navigatorKey.currentState!.pushNamed('home'),
          icon: Icon(LineAwesomeIcons.angle_left,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Bookmarks",
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
