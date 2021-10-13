import 'package:flutter/material.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/doctors_details.dart';
import 'package:smarthealth_care/screens/view_appointments.dart';

import 'doctor_buttons.dart';

class DoctorsListView extends StatelessWidget {
  const DoctorsListView({
    Key key,
    @required this.items, this.userModel,
  }) : super(key: key);
  final UserModel userModel;
  final List<DoctorModel> items;


  @override
  Widget build(BuildContext context) {
    return items.isEmpty?Expanded(child: Container(child: Center(child: Text('No doctor found!',style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.grey
    ),)),)):Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemExtent: 200.0,
        itemCount: items.length,
        itemBuilder: (context, index) {
          DoctorModel d = items[index];
          return ListTile(
            leading: Image.asset('assets/images/male_doctor.png'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doctor in ${d.city}',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                Text(
                  '⭐(${d.rating}/5.0) ${d.reviewsNum} Reviews',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                Text('${d.speciality}\n${d.qualification}'),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Book Appointment',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    DoctorButtons('In-Clinic', d.name),
                    DoctorButtons('Online', d.name),
                    DoctorButtons('Profile', d.name)
                  ],
                ),
              ],
            ),
            title: Text('${d.name}'),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DoctorDetails(doctorModel: d,userModel: userModel,),
                  // DoctorDetails(items[index], reviews),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
