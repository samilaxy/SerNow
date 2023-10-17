import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImageView extends StatelessWidget {
  final String imageUrl;
  final String placeholderUrl;
  const ZoomImageView(
      {super.key, required this.imageUrl, required this.placeholderUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(LineAwesomeIcons.angle_left, color: Theme.of(context).iconTheme.color),
            ),
      ),
      body: Center(
        child: SizedBox(
          height: 400,
            child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        )),
      ),
    );
  }
}
