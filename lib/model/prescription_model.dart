import 'package:smarthealth_care/model/user.dart';
import 'doctor_model.dart';
import 'medicineModel.dart';

class PrescriptionModel{
  dynamic symptoms;
  dynamic advices;
  DoctorModel doctor;
  UserModel patient;
  dynamic docEmail;
  dynamic patientEmail;
  dynamic patientName;
  dynamic patientContact;
  dynamic appointmentMode;
  dynamic date;
  PrescriptionModel({
    this.patient,
    this.patientName,
    this.docEmail,
    this.date,
    this.doctor,
    this.patientContact,
    this.patientEmail,
    this.advices,
    this.appointmentMode,
    this.symptoms,
  });
  factory PrescriptionModel.fromJson(Map<String, dynamic>map)=>
      PrescriptionModel(
        patient: UserModel.fromJson(map['patient']),
        patientName: map['patientName'],
        docEmail: map['docEmail'],
        date: map['date'],
        doctor: DoctorModel.fromJson(map['doctor']),
        patientContact: map['patientContact'],
        patientEmail: map['patientEmail'],
        advices: map['advices'],
        appointmentMode: map['appointmentMode'],
        symptoms: map['symptoms'],
      );
  Map<String, dynamic> toMap()=>{
    'patient': patient.toMap(),
    'patientName': patientName,
    'docEmail': docEmail,
    'date' : date,
    'doctor' : doctor.toMap(),
    'patientContact' : patientContact,
    'patientEmail' : patientEmail,
    'advices': advices,
    'symptoms' : symptoms,
  };
}
