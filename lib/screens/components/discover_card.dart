
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
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      child: Container(
         width: 150.0,
        decoration:  BoxDecoration(
                    borderRadius:  BorderRadius.circular(10,
                    )),
           // margin: const EdgeInsets.all(1.0),
            // Set the width of each card
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                   width: double.infinity,
                   // height: 180.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageWithPlaceholder(imageUrl: widget.service.img, placeholderUrl: noImg)),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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