import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/components/date_row.dart';
import 'package:smarthealth_care/components/time_slot.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/appoint_model.dart';
import 'package:smarthealth_care/model/datesModel.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/slots_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/navigationScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pay/pay.dart';
class BookAppointment extends StatefulWidget {
  final DoctorModel doctorModel;
  final UserModel userModel;
  const BookAppointment({Key key, this.doctorModel, this.userModel}) : super(key: key);

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool isChecked = true;
  String selectedTimeSlot ;
  int selectedSlotNumber;
  TextEditingController patientNameInputController;
  TextEditingController mobileNumInputController;
  List<SlotsModel> timeSlots = [];
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<AppointmentModels> appointments = [];
  List<String> bookedAppointments = [];
  List<DateModel> dates = [];
  final _currentDate = DateTime.now();
  final _dateFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  Color color = Colors.transparent;
  static const paymentItems = [PaymentItem(label : 'amount',amount: '1500',status: PaymentItemStatus.final_price)];
  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,11}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("View Appointments"),
      onPressed: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavigationScreen(selectedTab: 4,)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Booked Appointment"),
      content: Text("Your appointment is booked with Dr. Shabir."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  // AlertDialog alertDialog = AlertDialog(
  //
  // )
  String selectedDate;
  @override
  void initState() {
    patientNameInputController = TextEditingController();
    mobileNumInputController = TextEditingController();
    super.initState();
    getDates();
    getSlots();
  }
  void getDates(){
    for (int i = 0; i < 7; i++) {
      final date = _currentDate.add(Duration(days: i));
      final day = DateFormat('EEEE').format(date);
      dates.add(DateModel(date: _dateFormatter.format(date),month: _monthFormatter.format(date),day: day));
      selectedDate = '${dates[0].date} ${dates[0].month}';
    }
  }
  Widget getRow(){
    List<Widget> list = [];
    for(int i=0;i<dates.length;i++){
      list.add(DateRow(
        selectedButton: selectedDate,
        color: color,
        press: () {
          setState(() {
            selectedDate = '${dates[i].date} ${dates[i].month}';
            timeSlots.clear();
            bookedAppointments.clear();
            getSlots();
          });
        },
        day: dates[i].day,
        date: dates[i].date,
        month: dates[i].month,
      ),);
      list.add(SizedBox(width: 10.0,));
    }
    return Row(children: list,);
  }
  Future<void> bookAppointment() async {
    AppointmentModels appointmentModel = AppointmentModels();
    appointmentModel.doctor = widget.doctorModel;
    appointmentModel.patient = widget.userModel;
    appointmentModel.selectedSlot = selectedTimeSlot;
    appointmentModel.paidOn = DateTime.now();
    appointmentModel.docEmail = widget.doctorModel.docEmail;
    appointmentModel.patientEmail = widget.userModel.email;
    String expiryTime = selectedTimeSlot;
    appointmentModel.patientName = patientNameInputController.text;
    appointmentModel.patientContact = mobileNumInputController.text;
    appointmentModel.appointmentMode = 'Clinic';
    print(expiryTime.substring(5,7));
    int min = int.parse(expiryTime.substring(5,7));
    int hour = int.parse(expiryTime.substring(0,2));
    String time = expiryTime.substring(7);
    if(min + 20==60){
      if(hour + 1 ==12){
        if(time.substring(0,1)=='A'){
          time = 'P' + time.substring(1);
        }
        else{
          time = 'A' + time.substring(1);
        }
      }
      hour++;
      min = 0;
    }
    else{
      min = min + 20;
    }
    expiryTime = hour<10?'0$hour : ':'$hour : ';
    expiryTime = expiryTime + (min<10?'0$min':'$min');
    expiryTime = expiryTime + time;
    appointmentModel.expiresOn = expiryTime;
    appointmentModel.amount = widget.doctorModel.fee;
    appointmentModel.id = selectedSlotNumber;
    appointmentModel.transactionId = DateTime.now().microsecondsSinceEpoch;
    appointmentModel.date = selectedDate;
    appointmentModel.appointmentStatus = 'Pending';
    var res = await databaseMethods.bookAppointment(appointmentModel);
    if(res.runtimeType == String){
      _showToast(res.toString());
    }
    print('done');
  }
  Future<dynamic> getAppointments() async {
    print(selectedDate);
    var res = await FirebaseFirestore.instance
        .collection('Appointments')
        .where('docEmail', isEqualTo: widget.doctorModel.docEmail)
        .where('date', isEqualTo: selectedDate)
        .get();
    if (res.docs.length==0){
      return false;
    }

    res.docs.forEach((element) {
      AppointmentModels appointList = AppointmentModels.fromJson(element.data());
      appointments.add(appointList);
    });
    setState(() {
      // busy = Res.toggle(busy);
      appointments.length;
    });
    if(appointments.isNotEmpty){
      for(int i=0;i<appointments.length;i++){
        bookedAppointments.add(appointments[i].selectedSlot);
        print(bookedAppointments[i]);
        print(i);
      }
      setState(() {
        bookedAppointments.length;
      });
    }
    return true;

  }
  Future<void> getSlots() async {

    var res = await getAppointments();

    String sTime = widget.doctorModel.startTime;
    String eTime = widget.doctorModel.endTime;
    print(sTime.length);
    int startHour = int.parse(sTime.substring(0,2));
    int endHour = int.parse(eTime.substring(0,2));
    bool pmAm = false;
    bool amPm = false;
    if(res !=null){
      if(widget.doctorModel.startTime.contains('PM')&&widget.doctorModel.endTime.contains('AM')){
        startHour = startHour;
        endHour = endHour==12?startHour==endHour?endHour+12:endHour:endHour+12;
        pmAm = true;
      }
      else if(widget.doctorModel.startTime.contains('AM')&&widget.doctorModel.endTime.contains('PM')){
        startHour = startHour;
        endHour = endHour==12?startHour==endHour?endHour+12:endHour:endHour+12;
        amPm = true;
      }
      else{
        print('in');
        startHour = startHour;
        endHour = widget.doctorModel.endTime.contains('AM')?startHour==12?(endHour + 12):endHour:startHour==12?(endHour+12):endHour;

      }
      print(startHour);
      print(endHour);

      int startMin = int.parse(sTime.substring(5,7));
      int i = 0;
      while(startHour!=endHour){
        String hour = startHour<10?'0$startHour':startHour>12?'${startHour-12}':'$startHour';
        if(int.parse(hour.substring(0))<10){
          hour = '0$hour';
        }
        String min = startMin<10?'0$startMin':'$startMin';
        if(pmAm && res == false){
          timeSlots.add(SlotsModel(slotNumber: i,hour: hour,min: min,time: startHour<12?'PM':startHour==12?'AM':startHour>12?'AM':'PM'));
        }
        else if(pmAm && res == true){
          String amOrPm = startHour<12?'PM':startHour == 12?'AM':startHour>12?'AM':'PM';
          if(!bookedAppointments.contains('$hour : $min$amOrPm')){
            timeSlots.add(SlotsModel(slotNumber: i,hour: hour,min: min,time: startHour<12?'PM':startHour==12?'AM':startHour>12?'AM':'PM'));
          }
          else{
            i++;
          }
        }
        else if(amPm && res == false){
          timeSlots.add(SlotsModel(slotNumber: i,hour: hour,min: min,time: startHour<12?'AM':startHour==12?'PM':startHour>12?'PM':'AM'));
        }
        else if(amPm && res == true){
          String amOrPm = startHour<12?'AM':startHour==12?'PM':startHour>12?'PM':'AM';
          if(!bookedAppointments.contains('$hour : $min$amOrPm')){
            timeSlots.add(SlotsModel(slotNumber: i,hour: hour,min: min,time: startHour<12?'AM':startHour==12?'PM':startHour>12?'PM':'AM'));
          }
          else{
            i++;
          }
        }
        else{
          if(res == false){
            timeSlots.add(SlotsModel(slotNumber: i,hour: hour,min: min,time: widget.doctorModel.startTime.contains('PM')&&widget.doctorModel.endTime.contains('PM')?'PM':'AM'));
          }
          else{
            String amOrPm = widget.doctorModel.startTime.contains('PM')&&widget.doctorModel.endTime.contains('PM')?'PM':'AM';
            if(!bookedAppointments.contains('$hour : $min$amOrPm')){
              timeSlots.add(SlotsModel(slotNumber: i,hour: hour,min: min,time: widget.doctorModel.startTime.contains('PM')&&widget.doctorModel.endTime.contains('PM')?'PM':'AM'));
            }
            else{
              i++;
            }
          }

        }
        if(startMin+20==60){
          startHour++;
          startMin = 0;
        }
        else{
          startMin = startMin + 20;
        }
        i++;
    }
    setState(() {
      timeSlots.length;
      print(timeSlots[0].slotNumber);
      selectedSlotNumber = timeSlots[0].slotNumber;
      selectedTimeSlot = '${timeSlots[0].hour} : ${timeSlots[0].min}${timeSlots[0].time}';
      print('${timeSlots[0].hour} : ${timeSlots[0].min}${timeSlots[0].time}');
    });

    }

  }
  List<Widget> buildItems(List<SlotsModel> list,String time) {
    List<Widget> widgets = [];
    for (SlotsModel item in list) {
      int hour = int.parse(item.hour);
      if(item.time == 'AM' && time=='morning'){
        widgets.add(TimeSlot(
          selectedTime: selectedTimeSlot,
          time: item,
          press: () {
            setState(() {
              selectedSlotNumber = item.slotNumber;
              selectedTimeSlot = '${item.hour} : ${item.min}${item.time}';
              print(selectedTimeSlot);
            });
          },
        ));
        widgets.add(SizedBox(width: 14));
      }
      else if((time=='afternoon' && item.time=='PM') && (hour<6  || hour==12)){
        widgets.add(TimeSlot(
          selectedTime: selectedTimeSlot,
          time: item,
          press: () {
            setState(() {
              selectedSlotNumber = item.slotNumber;
              selectedTimeSlot = '${item.hour} : ${item.min}${item.time}';
              print(selectedTimeSlot);
            });
          },
        ));
        widgets.add(SizedBox(width: 14));
      }
      else if((time == 'evening' && item.time=='PM')&&(hour>=6 && hour!=12)){
        widgets.add(TimeSlot(
          selectedTime: selectedTimeSlot,
          time: item,
          press: () {
            setState(() {
              selectedSlotNumber = item.slotNumber;
              selectedTimeSlot = '${item.hour} : ${item.min}${item.time}';
              print(selectedTimeSlot);
            });
          },
        ));

        widgets.add(SizedBox(width: 14));
      }


    }
    if(widgets.isNotEmpty){
      return widgets;
    }
    else{
      widgets.add(Container(child: Center(child: Text('No slots available in $time'),),));
      return widgets;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: MainAppBar('Book Appointment'),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Slot for Appointment',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: getRow(),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
              timeSlots.isNotEmpty?Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Morning',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          timeSlots.isEmpty?Container(child: Center(child: Text('No slots'),),):Wrap(
                            runSpacing: 15,
                            spacing: 6,
                            children: buildItems(timeSlots,'morning'),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Afternoon',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          timeSlots.isEmpty?Container(child: Center(child: Text('No slots'),),):Wrap(
                            runSpacing: 15,
                            spacing: 6,
                            children: buildItems(timeSlots,'afternoon'),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Evening',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          timeSlots.isEmpty?Container(child: Center(child: Text('No slots'),),):Wrap(
                            runSpacing: 15,
                            spacing: 6,
                            children: buildItems(timeSlots,'evening'),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ):Container(child: Center(child : CircularProgressIndicator()),),
                  SingleChildScrollView(
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Full Name*', hintText: 'John Doe'),
                            controller: patientNameInputController,
                            validator: (value) {
                              if (value.length == 0) {
                                return 'Please enter your name';
                              } else if (value.length < 3) {
                                return 'Please enter a valid first name.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Mobile Number'),
                            controller: mobileNumInputController,
                            validator: validateMobile,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                              ),
                              // Text(
                              //     'I agree with the terms and conditions of Smart Health Care.')
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'I agree with the terms and conditions of ',
                                    ),
                                    TextSpan(
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                      text: 'Smart Health Care.',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          const url = 'https://google.com/';
                                          if (await canLaunch(url)) {
                                            await launch(
                                              url,
                                              forceSafariVC: true,
                                              enableJavaScript: true,
                                            );
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.pinkAccent,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () {
                                if (_registerFormKey.currentState.validate()) {
                                  if (isChecked == true) {
                                    // showAlertDialog(context);
                                    bookAppointment();
                                  } else {
                                    _showToast('Please agree to our terms and conditions!');
                                  }
                                }
                              },
                              label: Text(
                                'Book Appointment',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              icon: Icon(
                                Icons.calendar_today,
                                size: 20.0,
                              ),
                            ),
                          ),
                    // GooglePayButton(
                    //   paymentConfigurationAsset: 'googlepay.json',
                    //   paymentItems: paymentItems,
                    //   style: GooglePayButtonStyle.flat,
                    //   type: GooglePayButtonType.pay,
                    //   width: 150,
                    //   height : 50,
                    //   onPaymentResult: (value){
                    //     bookAppointment();
                    //   },
                    //   loadingIndicator: const Center(child: CircularProgressIndicator()),
                    // )
                        ],
                      ),
                    ),

                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
