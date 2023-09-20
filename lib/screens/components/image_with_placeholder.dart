import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageProvider, fit: BoxFit.cover)),
            ),
        errorWidget: (context, url, error) {
          print("ERROR IS $error and url is $url");
          return  Container(
            width: double.infinity,
              height: double.infinity,
            child: Image.asset(placeholderUrl, fit: BoxFit.cover));
        },
        placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child: Image.asset(placeholderUrl),
            ) // Widget to display in case of an error.
        );
  }
}

class ShimmerLoadingIndicator extends StatelessWidget {
  const ShimmerLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }
}
