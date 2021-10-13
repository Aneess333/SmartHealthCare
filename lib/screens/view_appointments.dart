import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/components/custom_elevated.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/appoint_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/chatting_screen.dart';
import 'package:smarthealth_care/screens/doctors_details.dart';
import 'addreview.dart';
import 'appointment_details.dart';

class ViewAppointments extends StatefulWidget {
  final UserModel userModel;
  const ViewAppointments({Key key, this.userModel}) : super(key: key);
  @override
  _ViewAppointmentsState createState() => _ViewAppointmentsState();
}
class _ViewAppointmentsState extends State<ViewAppointments>
    with SingleTickerProviderStateMixin {
  String upcomingBtnSelected = 'All';
  String pastBtnSelected = 'All';
  bool isLoading = true;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Upcoming'),
    Tab(text: 'Past'),
  ];
  TabController _tabController;
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<AppointmentModels> allUpcomingAppointmentsList = [];
  List<AppointmentModels> allUpClinicAppointmentsList = [];
  List<AppointmentModels> allUpOnlineAppointmentsList = [];
  List<AppointmentModels> upcomingAppointmentsList = [];
  List<AppointmentModels> allCompletedAppointmentsList = [];
  List<AppointmentModels> allCompClinicAppointmentsList = [];
  List<AppointmentModels> allCompOnlineAppointmentsList = [];
  List<AppointmentModels> completedAppointmentsList = [];
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    getAppointments();
    // items.addAll(duplicateItems);
  }
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
  Future<void> getAppointments() async {
    var data = await databaseMethods.getAppointments(widget.userModel.email);
    if(data.runtimeType == String){
      _showToast(data.toString());
      return;
    }
    data.forEach((shot){
      AppointmentModels appointment = AppointmentModels.fromJson(shot.data());
      if(appointment.appointmentStatus=='Pending'){
        if(appointment.appointmentMode == 'Clinic'){
          allUpClinicAppointmentsList.add(appointment);
        }
        else if(appointment.appointmentMode == 'Video Consultation'){
          allUpOnlineAppointmentsList.add(appointment);
        }
        allUpcomingAppointmentsList.add(appointment);
      }
    else{
        if(appointment.appointmentMode == 'Clinic'){
          allCompClinicAppointmentsList.add(appointment);
        }
        else if(appointment.appointmentMode == 'Video Consultation'){
          allCompOnlineAppointmentsList.add(appointment);
        }
        allCompletedAppointmentsList.add(appointment);
      }

    });
    if(mounted){
      setState(() {
        allUpcomingAppointmentsList.length;
        allUpClinicAppointmentsList.length;
        allUpOnlineAppointmentsList.length;
        print(allUpcomingAppointmentsList.length);
        upcomingAppointmentsList.addAll(allUpcomingAppointmentsList);
        completedAppointmentsList.addAll(allCompletedAppointmentsList);
        isLoading = false;
      });
    }

  }
  getChatRoomId(String a, String b) {
    if (a.compareTo(b) == 1) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }
  createChatRoomAndStartConversation(String username) {
    if (username != widget.userModel.name) {
      String chatRoomId = getChatRoomId(username, widget.userModel.name);
      List<String> users = [username, widget.userModel.name];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChattingScreen(
                userModel: widget.userModel,
                chatRoomId: chatRoomId,
                userName: username,
              )));
    } else {
      _showToast("You can't chat with yourself!");
    }
  }
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: [
            isLoading?Container(child: Center(child: CircularProgressIndicator())):SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Stack(
                    children: [
                      SizedBox(
                        width: 30.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 13.0,
                              ),
                              CustomElevated(
                                btnSelected: upcomingBtnSelected,
                                btnTitle: 'All',
                                onPress: () {
                                  setState(() {
                                    upcomingBtnSelected = 'All';
                                    upcomingAppointmentsList.clear();
                                    upcomingAppointmentsList.addAll(allUpcomingAppointmentsList);
                                  });
                                },
                              ),
                              CustomElevated(
                                btnSelected: upcomingBtnSelected,
                                btnTitle: 'Video Consultation',
                                onPress: () {
                                  setState(() {
                                    upcomingBtnSelected = 'Video Consultation';
                                    upcomingAppointmentsList.clear();
                                    upcomingAppointmentsList.addAll(allUpOnlineAppointmentsList);
                                    print(allUpOnlineAppointmentsList.length);
                                  });
                                },
                              ),
                              CustomElevated(
                                btnSelected: upcomingBtnSelected,
                                btnTitle: 'In Clinic/Hospital',
                                onPress: () {
                                  setState(() {
                                    upcomingBtnSelected = 'In Clinic/Hospital';
                                    upcomingAppointmentsList.clear();
                                    upcomingAppointmentsList.addAll(allUpClinicAppointmentsList);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Filters'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          side: BorderSide(color: Colors.black54),
                        ),
                      )
                    ],
                  ),
                  ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: upcomingAppointmentsList.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 30.0,
                      );
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          'assets/images/male_doctor.png',
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              upcomingAppointmentsList[index].patientName,
                              style: TextStyle(
                                  color: Colors.lightBlue, fontSize: 12.0),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Appointment Time: ',
                                      style:
                                          TextStyle(color: Colors.greenAccent),
                                    ),
                                    TextSpan(
                                        text:
                                            '🕒 ${upcomingAppointmentsList[index].selectedSlot}'),
                                    TextSpan(
                                      text: '  |  ',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54.withOpacity(0.5),
                                      ),
                                    ),
                                    TextSpan(text: '${upcomingAppointmentsList[index].date}, 2021'),
                                  ]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  upcomingAppointmentsList[index].appointmentMode=='Video Consultation'?Icons.video_call:Icons.local_hospital_outlined,
                                  size: 16.0,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                upcomingAppointmentsList[index].appointmentMode=='Video Consultation'?Text('VideoCall'):Text(upcomingAppointmentsList[index].doctor.hospitalName)
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Button(btnTitle: '😊 View Profile',pressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorDetails(doctorModel: upcomingAppointmentsList[index].doctor,userModel: widget.userModel,)));
                                },),
                                Button(btnTitle: '📞 Call Doctor'),
                                Button(btnTitle: '💬 Chat Doctor',pressed: (){
                                 createChatRoomAndStartConversation(upcomingAppointmentsList[index].doctor.name);
                                },),
                              ],
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.black54.withOpacity(0.2),
                            ),
                          ],
                        ),
                        title: Text(
                          upcomingAppointmentsList[index].doctor.name,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentDetails(
                                appointmentModels: upcomingAppointmentsList[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            isLoading?Container(child: Center(child: CircularProgressIndicator())):SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Stack(
                    children: [
                      SizedBox(
                        width: 30.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 13.0,
                              ),
                              CustomElevated(
                                btnSelected: pastBtnSelected,
                                btnTitle: 'All',
                                onPress: () {
                                  setState(() {
                                    pastBtnSelected = 'All';
                                    completedAppointmentsList.clear();
                                    completedAppointmentsList.addAll(allCompletedAppointmentsList);
                                  });
                                },
                              ),
                              CustomElevated(
                                btnSelected: pastBtnSelected,
                                btnTitle: 'Video Consultation',
                                onPress: () {
                                  setState(() {
                                    pastBtnSelected = 'Video Consultation';
                                    completedAppointmentsList.clear();
                                    completedAppointmentsList.addAll(allCompOnlineAppointmentsList);
                                  });
                                },
                              ),
                              CustomElevated(
                                btnSelected: pastBtnSelected,
                                btnTitle: 'In Clinic/Hospital',
                                onPress: () {
                                  setState(() {
                                    pastBtnSelected = 'In Clinic/Hospital';
                                    completedAppointmentsList.clear();
                                    completedAppointmentsList.addAll(allCompClinicAppointmentsList);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Filters'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          side: BorderSide(color: Colors.black54),
                        ),
                      )
                    ],
                  ),
                  ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: completedAppointmentsList.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 30.0,
                      );
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          'assets/images/male_doctor.png',
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              completedAppointmentsList[index].patientName,
                              style: TextStyle(
                                  color: Colors.lightBlue, fontSize: 12.0),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14.0,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: completedAppointmentsList[index].selectedSlot),
                                    TextSpan(
                                      text: '  |  ',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54.withOpacity(0.5),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                      completedAppointmentsList[index].date,
                                    )
                                  ]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 16.0),
                                ),
                                TextSpan(
                                    text: completedAppointmentsList[index].appointmentStatus,
                                    style: TextStyle(
                                      color: completedAppointmentsList[index].appointmentStatus ==
                                              'Completed'
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                    ))
                              ]),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_hospital_outlined,
                                  size: 16.0,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(completedAppointmentsList[index].doctor.hospitalName)
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Button(
                                    btnTitle: '⭐ Add Reviews',
                                    pressed: completedAppointmentsList[index]
                                                .appointmentStatus ==
                                            'Completed'
                                        ? () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    AddTaskScreen());
                                          }
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Button(
                                    btnTitle: '💬 Contact Doctor',
                                    pressed: completedAppointmentsList[index]
                                                .appointmentStatus ==
                                            'Completed'
                                        ? (){
                      createChatRoomAndStartConversation(upcomingAppointmentsList[index].doctor.name);
                      }
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.black54.withOpacity(0.2),
                            ),
                          ],
                        ),
                        title: Row(
                          children: [
                            Text(
                              completedAppointmentsList[index].doctor.name,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentDetails(
                                appointmentModels: completedAppointmentsList[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final btnTitle;
  final Function pressed;
  const Button({
    Key key,
    this.btnTitle,
    this.pressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        btnTitle,
        style: TextStyle(
          fontSize: 11.0,
          color: Colors.blue,
        ),
      ),
      onPressed: pressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        onPrimary: Colors.transparent,
        shadowColor: Colors.transparent,
        side: BorderSide(
          color: Colors.blue.withOpacity(0.5),
        ),
      ),
    );
  }
}

class AppointmentButton extends StatelessWidget {
  const AppointmentButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onPrimary: Colors.transparent,
                side: BorderSide(
                  color: Colors.blue.withOpacity(0.5),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('⭐ Add Reviews',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                    )),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onPrimary: Colors.transparent,
                side: BorderSide(
                  color: Colors.blue.withOpacity(0.5),
                ),
              ),
              onPressed: () {},
              child: Text('📄Attach Reports',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.blue,
                  )),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  onPrimary: Colors.transparent,
                  side: BorderSide(
                    color: Colors.blue.withOpacity(0.5),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  '💬 Contact doctor',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.blue,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
