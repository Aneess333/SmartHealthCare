import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/appoint_model.dart';
import 'package:smarthealth_care/model/medicineModel.dart';
import 'package:smarthealth_care/model/prescription_model.dart';
class PrescribePatient extends StatefulWidget {
  final AppointmentModels appointmentModel;
  const PrescribePatient({Key key, this.appointmentModel}) : super(key: key);

  @override
  _PrescribePatientState createState() => _PrescribePatientState();
}

class _PrescribePatientState extends State<PrescribePatient> {
  List<MedicineModel> medicineModel=[];
  TextEditingController advicesTextEditingController = TextEditingController();
  TextEditingController symptomsTextEditingController = TextEditingController();
  TextEditingController  medicineInputController = TextEditingController();
  bool morningCheck = false;
  bool afternoonCheck = false;
  bool eveningCheck = false;
  String days = '1';
  String timing = 'After';
  List<String> timingList = ['Before','After'];
  final GlobalKey<FormState> _prescriptionFormKey = GlobalKey<FormState>();
  List<String> daysList = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30'];
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
  bool isLoading = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  Future<void>getPrescriptionDetails()async {
    var data = await databaseMethods.getPrescriptions('${widget.appointmentModel.date}${widget.appointmentModel.docEmail}${widget.appointmentModel.patientEmail}${widget.appointmentModel.id}');
    if (data.runtimeType == String) {
      _showToast(data.toString());
      return;
    }
    data.forEach((shot) {
      MedicineModel medic = MedicineModel.fromJson(shot.data());
      print(medic.evening);
    });
  }
  addPrescription() async {
    PrescriptionModel prescriptionModel = PrescriptionModel();
    prescriptionModel.patientName = widget.appointmentModel.patientName;
    prescriptionModel.patient = widget.appointmentModel.patient;
    prescriptionModel.symptoms = symptomsTextEditingController.text;
    prescriptionModel.advices = advicesTextEditingController.text.isEmpty?"Doctor didn't gave any advices!":advicesTextEditingController.text;
    prescriptionModel.patientEmail = widget.appointmentModel.patientEmail;
    prescriptionModel.patientContact = widget.appointmentModel.patientEmail;
    prescriptionModel.doctor = widget.appointmentModel.doctor;
    prescriptionModel.date = widget.appointmentModel.date;
    prescriptionModel.docEmail = widget.appointmentModel.docEmail;
    prescriptionModel.appointmentMode = widget.appointmentModel.appointmentMode;
    var res = await databaseMethods.givePrescription(prescriptionModel,medicineModel,'${widget.appointmentModel.date}${widget.appointmentModel.docEmail}${widget.appointmentModel.patientEmail}${widget.appointmentModel.id}');
    if(res.runtimeType == String){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kindly add medicine to your prescription!'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Prescribe ${widget.appointmentModel.patientName}'),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _prescriptionFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient Detail',style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold)),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Text('Patient Name :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                          Text('${widget.appointmentModel.patientName}',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),

                        ],
                      ),
                  SizedBox(height: 5.0,),
                      Row(
                        children: [
                          Text('Appointment Id# :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                          Text('${widget.appointmentModel.transactionId}',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),

                        ],
                      ),
                  SizedBox(height: 5.0,),
                      Row(
                        children: [
                          Text('Patient City :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                          Text('${widget.appointmentModel.patient.city}',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),

                        ],
                      ),
                  SizedBox(height: 5.0,),
                      Row(
                        children: [
                          Text('Patient Age :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                          Text('24 Years',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),

                        ],
                      ),
                  SizedBox(height: 5.0,),
                      Row(
                        children: [
                          Text('Patient Gender :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400),),
                          Text('Female',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),

                        ],
                      ),
                  SizedBox(height: 20.0,),
                  Text('Symptoms',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)), SizedBox(height: 8,),
                  TextFormField(
                    maxLength: 300,
                    maxLines: 6,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: symptomsTextEditingController,
                    validator: (value){
                      if(value.length==0){
                        return 'Please write symptoms of patient disease!';
                      }
                      else if(value.length<15){
                        return 'At least 15 characters are required!';
                      }
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Symptoms',
                      hintStyle: TextStyle(
                        fontSize: 14,
                          color: Color(0xFFB8bbbb)
                      ),
                    ),
                    style: TextStyle(fontSize: 17)
              ),
                  Text('Create Prescriptions',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  TextField(
                    controller: medicineInputController,
                    decoration:
                    InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: 'Medicine Name',
                      hintText: 'Medicine Name',

                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 14
                      ),
                    ),
                    style: TextStyle(fontSize: 17)
              ),
              SizedBox(height: 20.0,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Text('Days',style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17
                          ),),
                          SizedBox(width: 30,),
                          DropdownButton(
                            value: days,
                            items: daysList.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,style: TextStyle(
                                    color: Color(0xFFB8bbbb)
                                ),),
                              );
                            }).toList(),
                            onChanged: (String newValue){
                              setState(() {
                                days = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Text('Before/After meal',style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17
                          ),),
                          SizedBox(width: 30,),
                          DropdownButton(
                            value: timing,
                            items: timingList.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,style: TextStyle(
                                  color: Color(0xFFB8bbbb)
                                ),),
                              );
                            }).toList(),
                            onChanged: (String newValue){
                              setState(() {
                                timing = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
              ),
              SizedBox(height: 10.0,),
              Row(
                  children: [
                    Text('Morning'),
                    Checkbox(
                      value: morningCheck,
                      onChanged: (newValue) {
                        setState(() {
                          morningCheck = !morningCheck;
                        });
                      },
                    ),
                    Text('Afternoon'),
                    Checkbox(
                      value: afternoonCheck,
                      onChanged: (newValue) {
                        setState(() {
                          afternoonCheck = !afternoonCheck;
                        });
                      },
                    ),
                    Text('Evening'),
                    Checkbox(
                      value: eveningCheck,
                      onChanged: (newValue) {
                        setState(() {
                          eveningCheck = !eveningCheck;
                        });
                      },
                    ),
                    ElevatedButton(child: Text('Add to medicine list'),onPressed: (){
                      if(medicineInputController.text.length<4){
                        _showToast('At least 4 characters are required for medicine name! ');
                        return;
                      }
                      else if(!morningCheck && !afternoonCheck && !eveningCheck){
                        _showToast('At least check one of the time to take medicine! ');
                        return;
                      }
                      else{
                        setState(() {
                          medicineModel.add(MedicineModel(days: days,afternoon: afternoonCheck,evening: eveningCheck,morning: morningCheck,beforeOrAfter: timing,medicineName: medicineInputController.text));
                        });
                      }
                    },),

                  ],
              ),
              SizedBox(height: 10.0,),
              medicineModel.isNotEmpty?Text('Medicine List',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)):Container(height: 0,),
                      medicineModel.isNotEmpty?SizedBox(height: 8,):Container(height: 0,),
                    ],
                  ),
                ),
              ),
              medicineModel.isEmpty?Container(height: 0,):SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      for(MedicineModel medicine in medicineModel) Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF6c6f6f)),
                              color: Color(0xFF414343)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${medicine.medicineName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Text('Morning'),
                                      SizedBox(width: 10,),
                                      Container(decoration: BoxDecoration(
                                        color: medicine.morning?Colors.greenAccent:Colors.white,
                                      ),width: 15, height: 15,child: Icon(medicine.morning?Icons.check:Icons.clear,color: medicine.morning?Colors.white:Colors.redAccent,size: 15,),),
                                      SizedBox(width: 30,),
                                      Text('Afternoon'),
                                      SizedBox(width: 10,),
                                      Container(decoration: BoxDecoration(
                                        color: medicine.afternoon?Colors.greenAccent:Colors.white,
                                      ),width: 15, height: 15,child: Icon(medicine.afternoon?Icons.check:Icons.clear,color: medicine.afternoon?Colors.white:Colors.redAccent,size: 15,)),
                                      SizedBox(width: 30,),
                                      Text('Evening'),
                                      SizedBox(width: 10,),
                                      Container(decoration: BoxDecoration(
                                        color: medicine.evening?Colors.greenAccent:Colors.white,
                                      ),width: 15, height: 15,child: Icon(medicine.evening?Icons.check:Icons.clear,color: medicine.evening?Colors.white:Colors.redAccent,size: 15,)),
                                      SizedBox(width: 30,),

                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text('Course duration :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),),
                                      Text('${medicine.days} Days',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),

                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Text('Time to take medicine :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),),
                                      Text('${medicine.beforeOrAfter} Meal',style: TextStyle(color: Color(0xFFD4d8d8),fontSize: 14.0),),
                                      SizedBox(width: 50.0),
                                      GestureDetector(onTap: (){
                                        medicineModel.removeAt(medicineModel.indexOf(medicine));
                                        setState(() {
                                          medicineModel.length;
                                        });
                                      },child: Icon(Icons.delete,color: Colors.redAccent,)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0,)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('Advices',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                    SizedBox(height: 12,),
              TextField(
                  maxLength: 300,
                  maxLines: 6,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: advicesTextEditingController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey,),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'You can give advice to your patient',
                    hintStyle: TextStyle(
                    color: Color(0xFFB8bbbb),
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(fontSize: 17)
              ),
              Container(child: Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: (){
                    if(_prescriptionFormKey.currentState.validate()){
                      if(medicineModel.isNotEmpty){
                        addPrescription();
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kindly add medicine to your prescription!'),
                          ),
                        );
                        return;
                      }
                    }
                  },child: Text('Confirm Prescription'))),
                  Expanded(child: ElevatedButton(onPressed: (){
                    getPrescriptionDetails();
                  },child: Text('Confirm Prescwekfjkweription'))),
                ],
              ),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
