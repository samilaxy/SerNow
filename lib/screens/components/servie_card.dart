
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serv_now/models/service_model.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';

import '../../Utilities/constants.dart';

class ServiceCard extends StatelessWidget {

  final ServiceModel service;

   const ServiceCard({
    super.key,
    required this.service
  });
  
  @override
  Widget build(BuildContext context) {
    String currency = "\$";
    return Card(
      elevation: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: 150,
                child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                     width: double.infinity,
                      height: 180.0,
                    child: ImageWithPlaceholder(imageUrl: service.imgUrls[0], placeholderUrl: noImg),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 55,
                     width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            service.title,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                       const SizedBox(height: 0.0),
                        Text(
                          '$currency${service.price}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 25,
                        height: 25,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                                color: Colors.grey,
                                child: ImageWithPlaceholder(
                                    imageUrl: service.user?.img ?? "",
                                    placeholderUrl: tProfileImage)))),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.user?.fullName ?? "",
                                maxLines: 1,
                                style: GoogleFonts.poppins(fontSize: 12)),
                            Text(service.category,
                                maxLines: 1,
                                style: GoogleFonts.poppins(fontSize: 8)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      child: Padding(
                        padding: const EdgeInsets.only(right:0.0),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(size: 20, Icons.bookmark, color: service.isFavorite ? mainColor : Colors.grey)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 10),
              child: SizedBox(
                // height: 10,
                child: Row(
                 mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(service.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: Icon(size: 12, Icons.location_on),
                    ),
                ],
                ),
              ),             
            )
          ],
        ),
      ),
    );
  }
}
