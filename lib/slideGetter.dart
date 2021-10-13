import 'package:intro_slider/slide_object.dart';
import 'package:flutter/material.dart';

class SlideGetter {
  static Slide getSlide(
      String pageTitle, String description, String imagePath) {
    return Slide(
      title: pageTitle,
      styleTitle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 50.0,
      ),
      marginTitle: EdgeInsets.only(top: 70.0, bottom: 100.0),
      description: description,
      pathImage: imagePath,
      widthImage: 300.0,
      heightImage: 300.0,
      styleDescription: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
        fontFamily: 'Source Sans Pro',
      ),
      marginDescription:
          EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
      backgroundColor: Colors.blueAccent,
    );
  }
}
