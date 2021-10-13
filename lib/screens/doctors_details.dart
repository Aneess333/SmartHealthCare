import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/rating.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/book_appointment.dart';

class DoctorDetails extends StatefulWidget {
  final DoctorModel doctorModel;
  final UserModel userModel;
  const DoctorDetails( {Key key, this.doctorModel, this.userModel})
      : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  static List<String> reviews = [
    "Everybody at the office was very helpful and friendly. The doctor took the time to listen and explain everything.",
    "He is very much qualified and experience doctor. It was a very nice visit to his clinic.",
    "His treatment procedure was totally painless. Highly recommended",
  ];
  final patients = [
    "Usman Haider",
    "Shahid Zafar Pasha",
    "Adil Shehzad",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(widget.doctorModel.name),
      body: SingleChildScrollView(
        child: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 100.0,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(
                        'assets/images/male_doctor.png',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⭐(5.0/5.0) jkew Reviews',
                            style: TextStyle(
                              color: Colors.lightBlue,
                            ),
                          ),
                          Text(
                              '${widget.doctorModel.speciality}\n${widget.doctorModel.qualification}'),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                      title: Text(
                        widget.doctorModel.name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await showDialog(
                            context: context, builder: (_) => ImageDialog());
                      },
                    );
                  },
                ),
                Divider(
                  color: Color(0xFF444444),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColumnCreator(Icons.medical_services_outlined, 'Wait Time',
                        '${widget.doctorModel.waitTime} mins'),
                    ColumnCreator(Icons.medical_services_outlined, 'Experience',
                        '${widget.doctorModel.experience} Years'),
                    ColumnCreator(
                        Icons.thumb_up, 'Patient Satisfication', '${widget.doctorModel.patientSatisfaction}%'),
                    ColumnCreator(Icons.people_alt_outlined,
                        'Client/Staff Score', '100%'),
                  ],
                ),
                Divider(
                  color: Color(0xFF444444),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Shifa International Hospital',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 15.0,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ItemsRow(Icons.money, 'Fee', widget.doctorModel.fee),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Divider(),
                    ),
                    ItemsRow(
                        Icons.calendar_today, 'Days', 'Mon, Tue, Wed, Fri'),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Divider(),
                    ),
                    ItemsRow(Icons.access_time, 'Time', '03:00-08:00 PM'),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookAppointment(doctorModel: widget.doctorModel,userModel: widget.userModel,)),
                      );
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
                Text(
                  'Work Experience',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'Assistent Professor',
                  style: TextStyle(
                    color: Color(0xFF6E85B2),
                    fontSize: 13.0,
                  ),
                ),
                Text(widget.doctorModel.hospitalName),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'About Me',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                    widget.doctorModel.aboutDoc
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Patient Reviews About ${widget.doctorModel.name}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isLoading?Container(height: 200,decoration: BoxDecoration(border: Border.all(color: Colors.black54)),alignment: Alignment.center,child: Center(child: CircularProgressIndicator()))
                    :Container(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rating.length>1?allReviews?rating.length:1:rating.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.lightBlue,
                              child: Icon(Icons.person),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Container(
                                color: Colors.black12,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Overall Experience: ${rating[index].satisfaction}',
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        rating[index].review,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            title: Text(rating[index].patient),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                isLoading?Container(height: 0,):rating.length>1?GestureDetector(
                  onTap: (){
                    setState(() {
                      allReviews = !allReviews;
                    });
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      allReviews?'Close':'See All Reviews',
                      style: TextStyle(
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ):Container(height: 0,),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    getReviews();
    // TODO: implement initState
    super.initState();
  }
  bool isLoading = true;
  bool allReviews = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<RatingModel> rating = [];
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
  void getReviews()async{
    var data = await databaseMethods.getRatings(widget.doctorModel.name);
    print(data.length);
    setState(() {
      isLoading = !isLoading;
    });
    if(data.runtimeType == String){
      _showToast(data);
    }
    data.forEach((shot){
      rating.add(RatingModel.fromJson(shot.data()));
    });
    setState(() {
      rating.length;
    });
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/images/male_doctor.png'),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class ColumnCreator extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const ColumnCreator(this.icon, this.title, this.value, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Color(0xFF7DEDFF),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class ItemsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const ItemsRow(this.icon, this.label, this.value, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    icon,
                    size: 15.0,
                  ),
                ),
                TextSpan(
                  text: label,
                ),
              ],
            ),
          ),
          Text(
            value,
          ),
        ],
      ),
    );
  }
}
