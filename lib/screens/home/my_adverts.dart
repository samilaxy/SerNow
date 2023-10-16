
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serv_now/Utilities/constants.dart';
import 'package:serv_now/controllers/my_adverts_provider.dart';
import 'package:serv_now/main.dart';
import 'package:serv_now/screens/components/my_advert_card.dart';


class MyAdverts extends StatefulWidget {
  const MyAdverts({super.key});

  @override
  State<MyAdverts> createState() => _MyAdvertsState();
}

class _MyAdvertsState extends State<MyAdverts> with RouteAware {
  @override
  void didPush() {
   final myAdvert =
        Provider.of<MyAdvertsProvider>(context);
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
      final myAdvert =
        Provider.of<MyAdvertsProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: 
        Center(
          child:  
          Stack(
            children: [
               if (myAdvert.noData) Center(
             child: Text(
                    "No service created yet",
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
           ),
              myAdvert.dataState ? 
              SizedBox(
                child: Column(
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
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.90,
                crossAxisSpacing: 10.0),
            padding: const EdgeInsets.all(20),
            itemCount: myAdvert.data.length,
            itemBuilder: (BuildContext context, int index) {
              return MyAdvertCard(
               service: myAdvert.data[index] 
                );
            })
           ],
          ),
        )
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
          onPressed: () => navigatorKey.currentState!.pushNamed('profile'),
          icon: Icon(LineAwesomeIcons.angle_left,
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