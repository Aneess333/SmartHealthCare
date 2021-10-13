import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/authenticate.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/helper/helper_functions.dart';
import 'package:smarthealth_care/helper/userdetails.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/doctorsDashboard.dart';
import 'package:smarthealth_care/screens/navigationScreen.dart';
import 'package:smarthealth_care/services/auth.dart';

class LogIn extends StatefulWidget {
  final Function toggle;
  const LogIn({Key key, this.toggle}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isObscure = true;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pwdInputController = TextEditingController();
  Authenticate authenticate = Authenticate();
  String emailValidator(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String password) {
    if (password.isEmpty) {
      return 'Please enter password';
    } else if (password.length < 8) {
      return 'Password length must be at least 8 characters';
    } else {
      return null;
    }
  }

  AuthMethods authMethods = AuthMethods();
  bool isLoading = false;
  List<UserModel> userModel = [];
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  QuerySnapshot userData;
  DatabaseMethods databaseMethods = DatabaseMethods();
  // Future<dynamic> signIn() {
  //   if (_loginFormKey.currentState.validate()) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     authMethods
  //         .signInWithEmailAndPassword(
  //             emailInputController.text, pwdInputController.text);
  //   }
  //   return null;
  //   // if (userData.size != 0) {
  //   //   UserModel user = UserModel.fromJson(value.data());
  //   //   print('yo');
  //   //   if(user.userType == 'patient'){
  //   //     setState(() async {
  //   //       final _prf = await SharedPreferences.getInstance();
  //   //       _prf.setString('user', jsonEncode(user.toMap()));
  //   //       print('here');
  //   //       isLoading = false;
  //   //       return user;
  //   //
  //   //     });
  //   //
  //   //
  //   //   }
  //   //   else{
  //   //     DoctorModel doctorModel = DoctorModel.fromJson(value.date());
  //   //     final _prf = await SharedPreferences.getInstance();
  //   //     print('there');
  //   //     _prf.setString('doctor', jsonEncode(doctorModel.toMap()));
  //   //     return doctorModel;
  //   //   }
  //   // }
  //
  // }
  Future<dynamic> signIn() async {
    try {
      if(_loginFormKey.currentState.validate()){
        setState(() {
          isLoading = true;
        });
        UserCredential action = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailInputController.text, password: pwdInputController.text);
        if (action.user != null) {
          print('a');
          //get user data
          var data = await databaseMethods.getUsersByEmail(emailInputController.text);
          if(data.runtimeType == String){
            _showToast(data.toString());
            return;
          }
          data.forEach((shot){
            print('b');
            userModel.add(UserModel.fromJson(shot.data()));
          });
          final _prf = await SharedPreferences.getInstance();
          if(userModel[0].userType=='patient'){
            _prf.setString('user', jsonEncode(userModel[0].toMap()));
            setState(() {
              isLoading = false;
            });
            return userModel[0];
          }
            else{
            DoctorModel doctorModel;
            data.forEach((shot){
              print('b');
              doctorModel = DoctorModel.fromJson(shot.data());
            });
              print('there');
              _prf.setString('doctor', jsonEncode(doctorModel.toMap()));
              return doctorModel;
            }

        }
        return null;
      }

      }
    on FirebaseException catch (e) {
      _showToast(e.message);
      setState(() {
        isLoading = false;
      });
      return ;
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Sign In'),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: textFieldInputDecoration('email'),
                              controller: emailInputController,
                              validator: emailValidator,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'password',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              controller: pwdInputController,
                              obscureText: _isObscure,
                              validator: pwdValidator,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Forgot Password?'),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var user = await signIn();
                          print(user);
                          if(user!=null && user.runtimeType == UserModel){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserDetail()));
                        }
                          else if(user!=null && user.runtimeType == DoctorModel){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserDetail()));
                          }},
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFF007EF4), Color(0xFF2A75BC)]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Sign In with Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an Account yet? ",
                            style: TextStyle(fontSize: 17),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Register now',
                                style: TextStyle(
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

