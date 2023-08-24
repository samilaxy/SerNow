import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

// class ImageWithPlaceholder extends StatelessWidget {
//   final String imageUrl;
//   final String placeholderUrl;
  
//   ImageWithPlaceholder({ required this.imageUrl, required this.placeholderUrl });

//   @override
//   Widget build(BuildContext context) {
//     return FadeInImage(
//       placeholder: AssetImage(placeholderUrl), // Placeholder image
//       image: NetworkImage(imageUrl), // Network image
//       fit: BoxFit.cover,
//     );
//   }
// }

class ImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String placeholderUrl;
  
  ImageWithPlaceholder({required this.imageUrl, required this.placeholderUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 0), () => imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerLoadingIndicator(); // Show a loading indicator during the delay
        }

        if (snapshot.hasError) {
          return const Text('Error loading image'); // Show an error message if delay fails
        }

        return FadeInImage(
          placeholder: AssetImage(placeholderUrl), // Placeholder image
          image: NetworkImage(snapshot.data.toString()), // Network image
          fit: BoxFit.cover,
        );
      },
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
        height: 200,
        color: Colors.white,
      ),
    );
  }
}