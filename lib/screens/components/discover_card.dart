
import 'package:flutter/material.dart';
import 'package:serv_now/models/discover_model.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';
import 'package:serv_now/utilities/constants.dart';

class DiscoverCard extends StatelessWidget {

  final DiscoverModel service;

   const DiscoverCard({
    super.key,
    required this.service
  });
  

  @override
  Widget build(BuildContext context) {
    String currency = "\$";
    return Card(
      elevation: 1,
      child: Container(
            margin: const EdgeInsets.all(8.0),
            width: 300.0, // Set the width of each card
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                     width: double.infinity,
                      height: 200.0,
                    child: ImageWithPlaceholder(imageUrl: service.img, placeholderUrl: noImg),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Product Title ${service.title}',
                          style:const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                       const SizedBox(height: 4.0),
                        Text(
                          '$currency${service.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          );
        }  
}