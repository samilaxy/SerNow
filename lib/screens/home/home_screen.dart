import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/details_page_provider.dart';
import '../../controllers/home_provider.dart';
import '../../main.dart';
import '../../screens/components/shimmer_loader.dart';
import '../../utilities/constants.dart';
import '../components/servie_card.dart';
import 'service_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  int selectedIndex = 0;
  final List<String> _categories = [
    'General',
    'Barbers',
    'Hair Dressers',
    'Plumbers',
    'Fashion',
    'Mechanics',
    "Home Services",
    "Health & Fitness",
    "Others"
  ];
  @override
  void didPush() {
    final homeProvider = Provider.of<HomeProvider>(context);
    homeProvider.fetchAllServices();
    super.didPush();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final detailsProvider = Provider.of<DetailsPageProvider>(context);

    return Scaffold(
        appBar: const CustomAppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 35, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index; // Update the selected index
                          homeProvider.filtersServices(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              12.0), // Adjust the radius as needed
                          color: selectedIndex == index
                              ? mainColor // Highlight selected item
                              : const Color.fromARGB(
                                  255, 225, 220, 220), // Background color
                        ),
                        // height: 30,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(_categories[index],
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.black)),
                        )),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Stack(children: [
                if (homeProvider.noData || homeProvider.noFiltaData)
                  Center(
                    child: Text(
                      "No service found",
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                Container(
                  child: homeProvider.dataState
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                               // valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                                color: mainColor,
                                backgroundColor: Colors.grey,
                                strokeWidth: 6, 
                              ),
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
                        )
                      : GridView(detailsProvider: detailsProvider, homeProvider: homeProvider),
                ),
              ]),
            ),
          ],
        ));
  }
}

class GridView extends StatelessWidget {
  const GridView({
    super.key,
    required this.detailsProvider,
    required this.homeProvider,
  });

  final DetailsPageProvider detailsProvider;
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
        return CustomScrollView(slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(
                top: 10.0,
                right: 16,
                left: 16,
                bottom: 50), // Adjust the padding as needed
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GridTile(
                      child: GestureDetector(
                    onTap: () {
                      detailsProvider.serviceData =
                          homeProvider.data[index];
                      detailsProvider.fetchDiscoverServices();
                      detailsProvider.fetchRelatedServices();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ServiceDetailsPage(),
                        ),
                      );
                    },
                    child: homeProvider.dataState
                        ? const LoadingIndicator()
                        : ServiceCard(
                            service:
                                homeProvider.data[index]),
                  ));
                },
                childCount: homeProvider.data.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 210),
            ),
          ), // MainView(
          //   homeProvider: homeProvider,
          //   detailsProvider: detailsProvider)
        ]);
      });
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                width: 100,
                height: 100,
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
