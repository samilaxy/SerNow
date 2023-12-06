import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utilities/constants.dart';
import '../../controllers/my_adverts_provider.dart';
import '../../main.dart';
import '../../screens/components/my_advert_card.dart';
import '../components/shimmer_loader.dart';

class MyAdverts extends StatefulWidget {
  const MyAdverts({super.key});

  @override
  State<MyAdverts> createState() => _MyAdvertsState();
}

class _MyAdvertsState extends State<MyAdverts> with RouteAware {
  @override
  void didPush() {
    final myAdvert = Provider.of<MyAdvertsProvider>(context);
    myAdvert.fetchServices();
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
    final myAdvert = Provider.of<MyAdvertsProvider>(context);

    return Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: Stack(
            children: [
              if (myAdvert.noData)
                Center(
                  child: Text(
                    "No service created yet",
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              myAdvert.dataState
                  ? SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                              color: mainColor, strokeWidth: 6),
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
                  : GridView(myAdvert: myAdvert)
            ],
          ),
        ));
  }
}

class GridView1 extends StatelessWidget {
  const GridView1({
    Key? key,
    required this.myAdvert,
  }) : super(key: key);

  final MyAdvertsProvider myAdvert;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
            padding:
                const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GridTile(
                    child: MyAdvertCard(service: myAdvert.data[index]),
                  );
                },
                childCount: myAdvert.data.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 200,
              ),
            ))
      ],
    );
  }
}

class GridView extends StatelessWidget {
  const GridView({
    super.key,
    required this.myAdvert,
  });

  final MyAdvertsProvider myAdvert;

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
                    child: myAdvert.dataState
                        ? const LoadingIndicator()
                        : MyAdvertCard(service: myAdvert.data[index]));
              },
              childCount: myAdvert.data.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              // mainAxisExtent: 210
            ),
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
          onPressed: () => navigatorKey.currentState!.pushNamed('profile'),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("My Services",
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
