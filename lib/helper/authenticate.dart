import 'package:flutter/material.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/screens/login_screen.dart';
import 'package:smarthealth_care/screens/register_screen.dart';

import 'helper_functions.dart';

class Authenticate extends StatefulWidget {
  final String userType;
  const Authenticate({Key key, this.userType}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void initState() {
    super.initState();
  }
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  bool showSignIn = true;
  @override
  Widget build(BuildContext context) {
    return showSignIn == true && widget.userType == null
        ? LogIn(
            toggle: toggleView,
          )
        : Register(
      userType: widget.userType == null?'doctor':widget.userType,
            toggle: toggleView,
          );
  }
}
