import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 120,
              color: Colors.grey,
              child: ImageWithPlaceholder(
                  imageUrl: "", placeholderUrl: barberImg)),
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
                                  imageUrl: "",
                                  placeholderUrl: tProfileImage)))),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(serviceName,
                              maxLines: 1,
                              style: GoogleFonts.poppins(fontSize: 12)),
                          Text(serviceName,
                              maxLines: 1,
                              style: GoogleFonts.poppins(fontSize: 8)),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(size: 20, LineAwesomeIcons.bookmark, color: Colors.grey))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 43.0, right: 16),
            child: SizedBox(
              // height: 10,
              child: Row(
               mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(location, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(size: 12, Icons.location_on),
                  ),
               
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
