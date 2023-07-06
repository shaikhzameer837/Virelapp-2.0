import 'package:flutter/material.dart';

class OnBoarding {
  String image;
  String title;
  String discription;
  Color backgroundColor;
  OnBoarding({
    required this.image,
    required this.title,
    required this.discription,
    required this.backgroundColor,
  });
}

// Created By Flutter Baba
List<OnBoarding> contentsList = [
  OnBoarding(
    backgroundColor: const Color(0xFF000000),
    title: "Page 1 of Virel gaming",
    image: 'assets/images/Img_car1.svg',
    discription: "This is the First Page",
  ),
  OnBoarding(
    backgroundColor: const Color(0xFF000000),
    title: "Page 2 of Virel gaming",
    image: 'assets/images/Img_car2.svg',
    discription: "This is the Second Page",
  ),
  OnBoarding(
    backgroundColor: const Color(0xFF000000),
    title: "Page 3 of Virel gaming",
    image: 'assets/images/Img_car3.svg',
    discription: "This is the third Page",
  ),
  OnBoarding(
    backgroundColor: const Color(0xFF000000),
    title: "Page 4 of Virel gaming",
    image: 'assets/images/Img_car1.svg',
    discription: "This is the Fourth Page",
  ),
];