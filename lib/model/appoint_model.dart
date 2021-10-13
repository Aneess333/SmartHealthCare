
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/user.dart';

class AppointmentModels {
  dynamic id;
  dynamic transactionId;
  dynamic amount;
  dynamic expiresOn;
  dynamic paidOn;
  DoctorModel doctor;
  UserModel patient;
  dynamic docEmail;
  dynamic patientEmail;
  dynamic selectedSlot;
  dynamic date;
  dynamic appointmentStatus;
  String patientName;
  String patientContact;
  String appointmentMode;
  AppointmentModels(
      {this.id,
        this.appointmentMode,
        this.patientContact,
        this.patientName,
        this.appointmentStatus,
        this.date,
        this.transactionId,
        this.amount,
        this.expiresOn,
        this.paidOn,
        this.selectedSlot,
        this.doctor,
        this.patientEmail,
        this.docEmail,
        this.patient});

  factory AppointmentModels.fromJson(Map<String, dynamic> map) =>
      AppointmentModels(
        id: map['id'],
          transactionId: map['transactionId'],
          amount: map['amount'],
          expiresOn: map['expiresOn'],
          paidOn: map['paidOn'],
          doctor: DoctorModel.fromJson(map['doctor']),
          selectedSlot: map['selectedSlot'],
          patient: UserModel.fromJson(map['patient']),
          patientEmail: map['patientEmail'],
          docEmail: map['docEmail'],
        date: map['date'],
        appointmentStatus: map['appointmentStatus'],
        patientContact: map['patientContact'],
        patientName: map['patientName'],
        appointmentMode: map['appointmentMode']
      );

  Map<String, dynamic> toMap() => {
    'id' : id,
    'transactionId': transactionId,
    'amount': amount,
    'expiresOn': expiresOn,
    'paidOn': paidOn,
    'doctor': doctor.toMap(),
    'selectedSlot': selectedSlot,
    'patient': patient.toMap(),
    'patientEmail': patientEmail,
    'docEmail': docEmail,
    'date' : date,
    'appointmentStatus': appointmentStatus,
    'patientContact' : patientContact,
    'patientName' : patientName,
    'appointmentMode' : appointmentMode
  };
}
