// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthealth_care/components/custom_drawer.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/authenticate.dart';
import 'package:smarthealth_care/helper/helper_functions.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/chat_room_screen.dart';
import 'package:smarthealth_care/screens/choose_specialities.dart';
import 'package:smarthealth_care/screens/search_disease.dart';
import 'package:smarthealth_care/services/auth.dart';
import 'main_search_screen.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;

  const HomePage({Key key, this.userModel}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user ;
  AuthMethods authMethods = AuthMethods();
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkUser();
  }
  checkUser(){
    if(user == null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Authenticate()));
    }
  }
  ElevatedButton buildKey(String text, Icon icon, Function onPressed) {
    return ElevatedButton.icon(
      label: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
      ),
      icon: CircleAvatar(
        radius: 30.0,
        backgroundColor: Color(0xFFEEEEEE),
        child: icon,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black54),
        alignment: Alignment.centerLeft,
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0)),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.userModel.name!=null?widget.userModel.name:'sdk'),
          actions: [
            GestureDetector(
              onTap: () async {
                authMethods.signOut();
                final _prf = await SharedPreferences.getInstance();
                _prf.clear();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app),
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(userModel: widget.userModel,),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainSearch(userModel: widget.userModel,),
                      ),
                    );
                  },
                  child: TextField(
                    enabled: false,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        fillColor: Colors.black54,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search here'),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                buildKey(
                    'Book Appointment',
                    Icon(
                      Icons.schedule,
                      color: Colors.blueAccent,
                      size: 40.0,
                    ), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseSpeciality()),
                  );
                }),
                SizedBox(
                  height: 10.0,
                ),
                buildKey(
                    'Online Video Consultation',
                    Icon(
                      Icons.video_call,
                      color: Colors.blueAccent,
                      size: 40.0,
                    ), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseSpeciality()),
                  );
                }),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildKey(
                        'Call Doctor Now',
                        Icon(
                          Icons.call,
                          color: Colors.blueAccent,
                          size: 40.0,
                        ), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseSpeciality()),
                      );
                    }),
                    buildKey(
                        'Search Via Disease',
                        Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                          size: 40.0,
                        ), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchDisease()),
                      );
                    })
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: ElevatedButton(
                    child: Text('Chat Screen'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatRoom()));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


