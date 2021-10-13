import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/doctorsDashboard.dart';
import 'package:smarthealth_care/screens/navigationScreen.dart';
import 'package:smarthealth_care/services/auth.dart';

import 'authenticate.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key key}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  List<UserModel> userModel = [];
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  void initState() {
    super.initState();
    getUserInfo();
  }
  getUserInfo() async {
    final _prf = await SharedPreferences.getInstance();
    if(_prf.containsKey('user')){
      UserModel user =
      UserModel.fromJson(jsonDecode(_prf.getString('user')));
      print('yo');
      print(user.name);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationScreen(userModel: user,)));
    }
    else if(_prf.containsKey('doctor')){
      DoctorModel doctorModel = DoctorModel.fromJson(jsonDecode(_prf.getString('doctor')));
      print('bruh doc');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DoctorsDashboard(doctorModel: doctorModel,)));
    }
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Authenticate(),
        ),
      );
    }


    //updateUser(user.email);
  }
  void updateUser(String email) async {
    var data = await databaseMethods.getUsersByEmail(email);
    data.docs.forEach((shot){
      print('b');
      setState(() {
        userModel.clear();
      });
      userModel.add(UserModel.fromJson(shot.data()));
    });
    final _prf = await SharedPreferences.getInstance();
    _prf.setString('user', jsonEncode(userModel[0].toMap()));
    setState(() {
      userModel.add(userModel[0]);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: Text('Please wait'),),
        GestureDetector(
          onTap: () {
            authMethods.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.exit_to_app),
          ),
        )
      ],
    );
  }
}
