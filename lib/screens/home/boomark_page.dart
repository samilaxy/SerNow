import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _BookmarkPageState extends State<BookmarkPage> with RouteAware {
  @override
  void didPush() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);
    homeProvider.fetchBookmarkServices();
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
        body: Stack(children: [
          Visibility(
            visible: homeProvider.noBookData,
            child: Center(
              child: Text(
                "No service bookmarked yet",
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          homeProvider.isBook
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
              : GridView(
                  detailsProvider: detailsProvider, homeProvider: homeProvider),
        ]));
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
                        homeProvider.bookmarkData[index];
                    detailsProvider.fetchDiscoverServices();
                    detailsProvider.fetchRelatedServices();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceDetailsPage(),
                      ),
                    );
                  },
                  child: homeProvider.isBook
                      ? const LoadingIndicator()
                      : ServiceCard(service: homeProvider.bookmarkData[index]),
                ));
              },
              childCount: homeProvider.bookmarkData.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            navigatorKey.currentState!.pushNamed('home');
          },
          icon: Icon(Icons.arrow_back_ios_rounded,
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
