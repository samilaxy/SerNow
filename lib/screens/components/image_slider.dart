

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
              height: 200.0,
              aspectRatio: 16 / 9,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: widget.imageUrls.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
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
              icon: Icon(Icons.arrow_back),
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
              icon: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}