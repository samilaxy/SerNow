import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String placeholderUrl;

  ImageWithPlaceholder({required this.imageUrl, required this.placeholderUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, ImageProvider) => Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageProvider, fit: BoxFit.cover)),
            ),
        errorWidget: (context, url, error) {
          return  SizedBox(
            width: double.infinity,
              height: double.infinity,
            child: Image.asset(placeholderUrl, fit: BoxFit.cover));
        },
        placeholder: (context, url) => SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(placeholderUrl, fit: BoxFit.cover),
            ) // Widget to display in case of an error.
        );
  }
}


