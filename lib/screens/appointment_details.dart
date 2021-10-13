import 'package:flutter/material.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/model/appoint_model.dart';

class AppointmentDetails extends StatelessWidget {
  final AppointmentModels appointmentModels;
  const AppointmentDetails(
      {Key key, this.appointmentModels,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Appointment Details'),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: Column(
              children: [
                Text(
                  'Your Appointment ID #',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE7E0C9),
                  ),
                ),
                Text(
                  '${appointmentModels.id}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFFC2F784),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient: ',
                                  style: kTextStyle,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Doctor: ',
                                  style: kTextStyle,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Hospital: ',
                                  style: kTextStyle,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Address: ',
                                  style: kTextStyle,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Date: ',
                                  style: kTextStyle,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Status: ',
                                  style: kTextStyle,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Payment: ',
                                  style: kTextStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointmentModels.patientName,
                                  style: TextStyle(
                                    color: Color(0xFFFDF6F0),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(appointmentModels.doctor.name),
                                SizedBox(height: 10.0),
                                Text(appointmentModels.doctor.hospitalName),
                                SizedBox(height: 10.0),
                                Text('G-10 Markaz'),
                                SizedBox(height: 10.0),
                                Text(appointmentModels.date),
                                SizedBox(height: 10.0),
                                Text(
                                  appointmentModels.appointmentStatus,
                                  style: TextStyle(
                                    color: appointmentModels.appointmentStatus == 'Completed'
                                        ? Colors.greenAccent
                                        : appointmentModels.appointmentStatus == 'Cancelled'
                                            ? Colors.redAccent
                                            : Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text('Google Pay'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sub Total:',
                        style: TextStyle(
                          color: Color(0xFF3DB2FF),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointmentModels.doctor.fee,
                        style: TextStyle(
                          color: Color(0xFF3DB2FF),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
