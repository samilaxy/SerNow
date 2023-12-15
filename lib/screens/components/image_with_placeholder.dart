import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String placeholderUrl;

  const ImageWithPlaceholder({super.key, 
    required this.imageUrl,
    required this.placeholderUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imgProvider) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imgProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(placeholderUrl, fit: BoxFit.cover),
        );
      },
      placeholder: (context, url) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(placeholderUrl, fit: BoxFit.cover),
      ),
    );
  }
}


// class ImageWithPlaceholder extends StatelessWidget {
//   final String imageUrl;
//   final String placeholderUrl;

//   ImageWithPlaceholder({required this.imageUrl, required this.placeholderUrl});

//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//         imageUrl: imageUrl,
//         imageBuilder: (context, imgProvider) => Container(
//               width: MediaQuery.of(context).size.width,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: imgProvider, fit: BoxFit.cover)),
//             ),
//         errorWidget: (context, url, error) {
//           return  SizedBox(
//             width: double.infinity,
//               height: double.infinity,
//             child: Image.asset(placeholderUrl, fit: BoxFit.cover));
//         },
//         placeholder: (context, url) => SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: Image.asset(placeholderUrl, fit: BoxFit.cover),
//             ) // Widget to display in case of an error.
//         );
//   }
// }



