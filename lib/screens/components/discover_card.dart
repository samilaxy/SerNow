
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';
import 'package:serv_now/utilities/constants.dart';

class DiscoverCard extends StatefulWidget {

  final DiscoverModel service;

   const DiscoverCard({
    super.key,
    required this.service
  });

  @override
  State<DiscoverCard> createState() => _DiscoverCardState();
}

class _DiscoverCardState extends State<DiscoverCard> {
  @override
  Widget build(BuildContext context) {
    String currency = "\$";
    return Card(
      elevation: 1.0,
      child: Container(
         width: 160.0,
        decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius:  BorderRadius.only(
                       bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )),
           // margin: const EdgeInsets.all(1.0),
            // Set the width of each card
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                 
                   width: double.infinity,
                    height: 180.0,
                  child: ImageWithPlaceholder(imageUrl: widget.service.img, placeholderUrl: noImg),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                   width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.service.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     const SizedBox(height: 4.0),
                      Text(
                        '$currency${widget.service.price}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          );
        }  
}