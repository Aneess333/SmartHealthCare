import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:smarthealth_care/screens/login_screen.dart';
import 'package:smarthealth_care/screens/register_screen.dart';
import 'package:smarthealth_care/screens/usertype.dart';
import 'homepage.dart';
import 'package:smarthealth_care/slideGetter.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides.add(SlideGetter.getSlide(
        'ERASER',
        'Ye indulgence unreserved connection alteration appearance',
        'assets/images/slider1_image.png'));
    slides.add(SlideGetter.getSlide(
        'PENCIL',
        'Ye indulgence unreserved connection alteration appearance',
        'assets/images/slider2_image.png'));
    slides.add(
      SlideGetter.getSlide(
          'RULER',
          'Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of',
          'assets/images/slider3_image.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserType()));
      },
    );
  }
}
