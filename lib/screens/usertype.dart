import 'package:flutter/material.dart';
import 'package:smarthealth_care/helper/authenticate.dart';

class UserType extends StatelessWidget {
  const UserType({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authenticate(userType: 'patient',)));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width-30,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF007EF4),
                      Color(0xFF2A75BC)
                    ]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sign Up as a Patient',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authenticate(userType: 'doctor',)));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width-30,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sign Up as a Doctor',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
