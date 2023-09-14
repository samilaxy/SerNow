import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';

import '../../Utilities/constants.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String description;
  final String location;
  final String icon;

  const ServiceCard({
    super.key,
    required this.serviceName,
    required this.description,
    required this.location,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        height: 100,
        child: Column(
          children: [
             SizedBox(height: 100, width: 300, child: ImageWithPlaceholder(imageUrl: defualtImg, placeholderUrl: barberImg),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(serviceName, style: GoogleFonts.poppins(fontSize: 10)),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_add))
                ],
              ),
            ),
             Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(location, style: GoogleFonts.poppins(fontSize: 10)),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.location_on))
                ],
              ),
            ),
          ],
        )  
      ),
    );
  }

}
