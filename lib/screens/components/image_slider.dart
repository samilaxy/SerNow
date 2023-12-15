

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../screens/components/image_with_placeholder.dart';
import '../../utilities/constants.dart';

import '../home/zoom_imageview.dart';


class MyImageSlider extends StatefulWidget {
  final List<dynamic> imageUrls;

  const MyImageSlider({super.key, required this.imageUrls});

  @override
  // ignore: library_private_types_in_public_api
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 220.0,
              aspectRatio: 16 / 9,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            items: widget.imageUrls.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ZoomImageView(
                                          imageUrl: imageUrl,
                                  placeholderUrl: noImg,),
                                    ));
                    },
                    child: Container(
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ImageWithPlaceholder(
                                  imageUrl: imageUrl,
                                  placeholderUrl: noImg,
                                ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: IconButton(
              onPressed: () {
                _carouselController.previousPage();
              },
              icon: const Icon(LineAwesomeIcons.angle_left),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                _carouselController.nextPage();
              },
              icon: const Icon(LineAwesomeIcons.angle_right),
            ),
          ),
        ],
      ),
    );
  }
}