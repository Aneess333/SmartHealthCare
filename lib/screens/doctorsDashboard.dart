import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/authenticate.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/appoint_model.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/screens/prescribe_patient.dart';
import 'package:smarthealth_care/screens/view_appointments.dart';
import 'package:smarthealth_care/screens/view_appointments_doctor.dart';
import 'package:smarthealth_care/services/auth.dart';

class DoctorsDashboard extends StatefulWidget {
  final DoctorModel doctorModel;
  const DoctorsDashboard({Key key, this.doctorModel}) : super(key: key);

  @override
  _DoctorsDashboardState createState() => _DoctorsDashboardState();
}

class _DoctorsDashboardState extends State<DoctorsDashboard> {
  TextEditingController timeFromInputController = TextEditingController();
  TextEditingController timeToInputController = TextEditingController();
  String selectedDay = 'Mon';
  DatabaseMethods databaseMethods = DatabaseMethods();
  DoctorModel doctorModel;
  AuthMethods authMethods = AuthMethods();
  List<AppointmentModels> upcomingAppointments = [];
  List<AppointmentModels> completedAppointments = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingAppointments();
  }
  Future<void> getUpcomingAppointments()async{
    var data = await databaseMethods.getUpcomingAppointments(widget.doctorModel.docEmail, '24 Sep');
    var comData = await databaseMethods.getCompletedAppointments(widget.doctorModel.docEmail);
    if(comData.runtimeType == String){
      print('no com data');
    }
    else{
      data.forEach((shot){
        AppointmentModels appMod = AppointmentModels.fromJson(shot.data());
        upcomingAppointments.add(appMod);
      });
    }
    if(data.runtimeType == String){
      print('no data got');
    }
    else{
      comData.forEach((shot){
        AppointmentModels appMod = AppointmentModels.fromJson(shot.data());
        completedAppointments.add(appMod);
      });
    }

    setState(() {
      upcomingAppointments.length;
      completedAppointments.length;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset('assets/images/male_doctor.png', fit: BoxFit.cover,),
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
            )
          ],
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text('Welcome \nDr. Mohsin Ali Hashmi',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 40,),
              Text('Upcoming Appointment Today',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              isLoading?Container(child: Center(child: CircularProgressIndicator()),):ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: upcomingAppointments.length,
                  // >1?2:1
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          height: 190,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xFF5f5f5f)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${upcomingAppointments[index].patientName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                                  SizedBox(height: 5.0,),
                                  Text('ID#${upcomingAppointments[index].transactionId}'),
                                  SizedBox(height: 5.0,),
                                  Text(upcomingAppointments[index].patient.city),
                                  SizedBox(height: 5.0,),
                                  Text('24 years'),
                                  SizedBox(height: 5.0,),
                                  Text('Male'),
                                  SizedBox(height: 20.0,),
                                  Row(
                                    children: [
                                      AppointmentButtons(text: 'Call',appointmentModel: upcomingAppointments[index],),
                                      SizedBox(width: 5.0,),
                                      AppointmentButtons(text: 'Chat',),
                                      SizedBox(width: 5.0,)
                                    ],
                                  ),


                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text("Schedule",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${upcomingAppointments[index].selectedSlot}-${upcomingAppointments[index].expiresOn}'),],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              isLoading?Container(height: 0,):Container(alignment: Alignment.bottomRight,child: GestureDetector(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAppointmentsDoctor(doctorModel: widget.doctorModel,tabNumber: 1,)));
              },child: Text('View all upcoming appointments')),),
              SizedBox(height: 40,),
              // Container(child: Row(
              //   children: [
              //     Expanded(child: ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAppointments()));},child: Text('View All Appointments'))),
              //   ],
              // ),),
              Text('Completed Appointments',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              isLoading?Container(child: Center(child: CircularProgressIndicator()),):ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: completedAppointments.length,
                  // >1?2:1
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          height: 190,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xFF5f5f5f)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${completedAppointments[index].patientName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                                  SizedBox(height: 5.0,),
                                  Text('ID#${completedAppointments[index].transactionId}'),
                                  SizedBox(height: 5.0,),
                                  Text(completedAppointments[index].patient.city),
                                  SizedBox(height: 5.0,),
                                  Text('24 years'),
                                  SizedBox(height: 5.0,),
                                  Text('Male'),
                                  SizedBox(height: 20.0,),
                                  Row(
                                    children: [
                                      AppointmentButtons(text: 'Chat',),
                                      SizedBox(width: 5.0,),
                                      AppointmentButtons(text: 'Prescribe',)
                                    ],
                                  ),


                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              "https://www.phdmedia.com/pakistan/wp-content/uploads/sites/38/2015/05/temp-people-profile.jpg"),
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text("Schedule",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${completedAppointments[index].selectedSlot}-${completedAppointments[index].expiresOn}'),],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              isLoading?Container(height: 0,):Container(alignment: Alignment.bottomRight,child: GestureDetector(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAppointmentsDoctor(doctorModel: widget.doctorModel,tabNumber: 2,)));
              },child: Text('View all completed appointments')),),
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentButtons extends StatelessWidget {
  final String text;
  final AppointmentModels appointmentModel;
  const AppointmentButtons({
    Key key, this.text, this.appointmentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PrescribePatient(appointmentModel: appointmentModel,)));
      },
      child: Container(height: 40.0,width: 70.0,decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),child: Center(child: Text(text)),),
    );
  }
}

class DayButton extends StatelessWidget {
  final selectedDay;
  final String day;
  final Function onPressed;
  final bool active;
  const DayButton({
    Key key, this.day, this.onPressed, this.selectedDay, this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50.0,
        width: 55.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active?Colors.green:Colors.grey),
          color: selectedDay == day?Colors.blueAccent:Colors.transparent,
        ),
        child: Center(child: Text(day)),
        padding: EdgeInsets.all(10.0),
      ),
      onTap: onPressed,
    );
  }
}
