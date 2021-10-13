import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/edit_profile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key, this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text(userModel.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
            accountEmail: Text(userModel.email),
            currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "A",
              style: TextStyle(fontSize: 40.0),
            ),
          ),),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(userModel: userModel,)));
            },
            title: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10.0,),
                Text("Edit Profile"),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.contact_support_outlined),
                SizedBox(width: 10.0,),
                Text("Contact us"),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 10.0,),
                Text("Logout"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}