import 'package:flutter/material.dart';

class AppointmentModel {
  final String docName,
      patName,
      timeSlot,
      date,
      hospitalName,
      appointmentStatus;

  AppointmentModel(this.docName, this.patName, this.timeSlot, this.date,
      this.hospitalName, this.appointmentStatus);
}
