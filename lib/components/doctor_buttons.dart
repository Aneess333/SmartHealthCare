import 'package:flutter/material.dart';
import 'package:smarthealth_care/screens/doctors_details.dart';

class DoctorButtons extends StatelessWidget {
  final String btnTitle;
  final String speciality;
  const DoctorButtons(this.btnTitle, this.speciality, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        // onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DoctorDetails(speciality, reviews),
        //     ),
        //   );
        // },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            btnTitle,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          onPrimary: Colors.white,
          side: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
