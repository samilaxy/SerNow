import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';
import '../../utilities/constants.dart';
import '../components/pending_card.dart';
import '../components/shimmer_loader.dart';

class PendingServices extends StatefulWidget {
  const PendingServices({super.key});

  @override
  State<PendingServices> createState() => _PendingServicesState();
}

class _PendingServicesState extends State<PendingServices> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: Stack(children: [
            if (provider.noData)
              Center(
                child: Text(
                  "No pending service available",
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            provider.dataState
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
                : GridView(myAdvert: provider)
          ]),
        ));
  }
}

class GridView extends StatelessWidget {
  const GridView({
    super.key,
    required this.myAdvert,
  });

  final AdminProvider myAdvert;

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
                        : PendingCard(
                            service: myAdvert.data[index], index: index));
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
        ),
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
          onPressed: () => Navigator.pushNamed(context, 'profile'),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Pending Services",
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
