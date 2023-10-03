

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';
import 'package:serv_now/utilities/constants.dart';


class MyImageSlider extends StatefulWidget {
  final List<dynamic> imageUrls;

  MyImageSlider({required this.imageUrls});

  @override
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
                  return Container(
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ImageWithPlaceholder(
                                imageUrl: imageUrl,
                                placeholderUrl: noImg,
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