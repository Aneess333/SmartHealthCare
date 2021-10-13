import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/helper/helper_functions.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/chat_room_screen.dart';
import 'package:smarthealth_care/screens/homepage.dart';
import 'package:smarthealth_care/screens/main_search_screen.dart';
import 'package:smarthealth_care/screens/notificationScreen.dart';
import 'package:smarthealth_care/screens/view_appointments.dart';

class NavigationScreen extends StatefulWidget {
  final int selectedTab;
  final UserModel userModel;
  const NavigationScreen({Key key, this.selectedTab, this.userModel}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int messageNotifications = 0;
  DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedTab = widget.selectedTab==null?0:widget.selectedTab;
    });
    print(widget.userModel.email);
  }
  int _selectedTab = 0;
  List<Widget> _navigationalScreen = [
    HomePage(),




  ];
  Widget navigateAt(int selected) {
    if (selected == 0) {
      return HomePage(userModel: widget.userModel,);
    }
    else if (selected == 1) {
      print(widget.userModel.city);
      return MainSearch(userModel: widget.userModel,);
    }
    else if (selected == 2) {
      return NotificationScreen();
    }
    else if (selected == 3) {
      return ChatRoom(userModel: widget.userModel,);
    }
    else if (selected == 4) {
      return ViewAppointments(userModel: widget.userModel,);
    }
    return HomePage(userModel: widget.userModel,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index){
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: Color(0xff00acee),
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(label: 'Home',icon: Icon(Icons.home,color: _selectedTab == 0?Colors.lightBlueAccent:Colors.white,)),

          BottomNavigationBarItem(label: 'Search',icon: Icon(Icons.search,color: _selectedTab == 1?Colors.lightBlueAccent:Colors.white,)),
          BottomNavigationBarItem(label: 'Notifications',
            icon: Stack(
              children: <Widget>[
                Icon(Icons.notifications,color: _selectedTab == 2?Colors.lightBlueAccent:Colors.white,),
                Positioned(  // draw a red marble
                  top: 0.0,
                  right: 0.0,

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    alignment: Alignment.center,
                    child: Text('1',style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                )
              ]
            ),
          ),
          BottomNavigationBarItem(label: 'Messages',icon: Stack(
              children: <Widget>[
                Icon(Icons.message,color: _selectedTab == 3?Colors.lightBlueAccent:Colors.white,),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ]
          ),),
          BottomNavigationBarItem(label: 'Appointments',icon: Icon(Icons.bookmark_border,color: _selectedTab == 4?Colors.lightBlueAccent:Colors.white,)),
        ],
      ),
      body: navigateAt(_selectedTab),
    );
  }
}
