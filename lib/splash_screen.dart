import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthealth_care/helper/authenticate.dart';
import 'package:smarthealth_care/helper/userdetails.dart';
import 'package:smarthealth_care/screens/intro_screen.dart';
import 'package:smarthealth_care/screens/navigationScreen.dart';
import 'package:smarthealth_care/screens/prescribe_patient.dart';


class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  User user = FirebaseAuth.instance.currentUser;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Authenticate(),
          ),
        );
      }
      else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserDetail()));
      }
    }
    else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
