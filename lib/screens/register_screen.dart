import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/helper/helper_functions.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/doctorsDashboard.dart';
import 'package:smarthealth_care/screens/login_screen.dart';
import 'package:smarthealth_care/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggle;
  final String userType;
  const Register({Key key, this.toggle, this.userType}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  UserModel userModel = UserModel();
  DoctorModel doctorModel = DoctorModel();
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<String> cityNames = ['Islamabad','Karachi','Lahore','Faisalabad','Rawalpindi','Gujranwala', 'Peshawar','Multan','Hyderabad','Quetta','Bahawalpur','Sargodha','Sialkot','Sukkar','Larkana','Sheikhupura','RahimYarKhan','Jhang','DeraGhaziKhan','Gujrat','Sahiwal','Wah','Mardan','Kasur','Okara','Mingora','Nawabshah','Chiniot','Kotri','Hafizabad','Mirpur','Abbotabad','Jhelum','Muzaffarabad','Attock','Vehari'];
  List<String> specialities = [
    "Oral and Maxillofacial Surgeon",
    "Dentist",
    "Pediatric Gastroenterologist",
    "Hijama Specialist",
    "Rehabilitation",
    "Psychiatrist",
    "Radiologist",
    "Cancer Specialist / Oncologist",
    "Hematologist",
    "Speech Therapist",
    "Allergy Specialist",
    "Gynecologist",
    "Maternal Fetal Medicine Specialist",
    "Anesthetist",
    "Infectious Disease",
    "Audiologist",
    "Dermatologist",
    "Pediatric Cardiologist"
  ];
  bool isLoading = false;
  int groupValue = 0;
  AuthMethods authMethods = AuthMethods();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController fullNameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController pwdInputController = TextEditingController();
  TextEditingController confirmPwdInputController = TextEditingController();
  TextEditingController mobileNumInputController = TextEditingController();
  TextEditingController pmcInputController = TextEditingController();
  TextEditingController aboutDoctorInputController = TextEditingController();
  String cityName = 'Islamabad';
  String speciality = 'Oral and Maxillofacial Surgeon';
  String emailValidator(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String password) {
    if (password.isEmpty) {
      return 'Please enter password';
    } else if (password.length < 8) {
      return 'Password length must be at least 8 characters';
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{11}$)';
    print(widget.userType);
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number(11 digit)';
    }
    return null;
  }
  String validateAboutDoc(String value){
    if(value.length<250){
      return 'Minimum 250 Characters!';
    }
    return null;
  }
  void _showToast() {
    Fluttertoast.showToast(
        msg: 'Email is already in use',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  signMeUp() {
    if (_registerFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
              emailInputController.text, pwdInputController.text)
          .then((value) async {
        if (value == 'Email is Already in use') {
          _showToast();
          setState(() {
            isLoading = false;
          });
        } else {
          await new Future.delayed(const Duration(seconds: 1));
          if(widget.userType == 'patient'){
            userModel.name = fullNameInputController.text;
            userModel.email = emailInputController.text;
            userModel.mobileNumber = mobileNumInputController.text;
            userModel.userType = widget.userType;
            userModel.city = cityName;
            databaseMethods.uploadUserInfo(userModel.toMap());
          }
          else{
            doctorModel.name = fullNameInputController.text;
            doctorModel.docEmail = emailInputController.text;
            doctorModel.docMobileNumber = mobileNumInputController.text;
            doctorModel.userType = widget.userType;
            doctorModel.city = cityName;
            doctorModel.speciality = speciality;
            doctorModel.docPmc = pmcInputController.text;
            doctorModel.appointmentLead = groupValue == 0? 'yes' : 'no';
            doctorModel.aboutDoc = aboutDoctorInputController.text;
            databaseMethods.uploadDocInfo(doctorModel.toMap());
          }
          Map<String, String> doctorMap = {
            'name': fullNameInputController.text,
            'email': emailInputController.text,
            'mobileNumber': mobileNumInputController.text,
            'userType' : widget.userType,
            'city': cityName,
            'speciality' : speciality,
            'pmc' : pmcInputController.text,
            'aboutDoc' : aboutDoctorInputController.text,
            'appointmentsLead'  : groupValue==0?'yes':'no'
          };
         // widget.userType=='patient'?databaseMethods.uploadUserInfo(userMap):databaseMethods.uploadDocInfo(doctorMap);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LogIn()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Sign Up'),
      body: Container(
        alignment: Alignment.center,
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _registerFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your name';
                                  } else if (value.length < 4) {
                                    return 'Please enter a valid name(At least 4 Characters';
                                  }
                                  return null;
                                },
                                controller: fullNameInputController,
                                decoration:
                                    textFieldInputDecoration('full name'),
                                  style: TextStyle(fontSize: 17)
                              ),
                              TextFormField(
                                validator: emailValidator,
                                controller: emailInputController,
                                decoration: textFieldInputDecoration('email'),
                                  style: TextStyle(fontSize: 17)
                              ),
                              TextFormField(
                                obscureText: true,
                                validator: pwdValidator,
                                controller: pwdInputController,
                                decoration:
                                    textFieldInputDecoration('password'),
                                  style: TextStyle(fontSize: 17)
                              ),
                              Row(
                                children: [
                                  Text('Select City',style: TextStyle(
                                    color: Color(0xff767676),
                                    fontWeight: FontWeight.bold,
                                  fontSize: 17
                                  ),),
                                  SizedBox(width: 30,),
                                  DropdownButton(
                                    value: cityName,
                                    items: cityNames.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String newValue){
                                      setState(() {
                                        cityName = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              widget.userType=='doctor'?Row(
                                children: [
                                  Text('Choose Speciality',style: TextStyle(
                                      color: Color(0xff767676),
                                      fontWeight: FontWeight.bold,
                                  fontSize: 17
                                  ),),
                                  SizedBox(width: 30,),
                                  DropdownButton(
                                    value: speciality,
                                    items: specialities.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String newValue){
                                      setState(() {
                                        speciality = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ):Container(height: 0,),
                              widget.userType=='doctor'?TextFormField(
                                controller: pmcInputController,
                                decoration: textFieldInputDecoration('pmc registration number'),
                                  style: TextStyle(fontSize: 17),
                              ):Container(height: 0,),
                              TextFormField(
                                validator: validateMobile,
                                controller: mobileNumInputController,
                                decoration:
                                textFieldInputDecoration('mobile number',),
                                style: TextStyle(fontSize: 17),
                              ),
                              widget.userType=='doctor'?TextFormField(
                                  validator: validateAboutDoc,
                                  maxLength: 300,
                                  maxLines: 6,
                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  controller: aboutDoctorInputController,
                                  decoration: textFieldInputDecoration('About you'),
                                  style: TextStyle(fontSize: 17)
                              ):Container(height: 0,),
                              widget.userType=='doctor'?Column(
                                children: [
                                  Text('Do you want to grow your practice?(More patient leads)',style: TextStyle(
                                    fontSize: 16.0,
                                  ),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Yes',style: TextStyle(fontSize: 16.0),),
                                      Radio(value: 0, groupValue: groupValue,onChanged: (newValue){
                                        setState(() {
                                          groupValue = newValue;
                                          print(groupValue);
                                        });
                                      }),
                                      SizedBox(width: 20.0,),
                                      Text('No',style: TextStyle(fontSize: 16.0)),
                                      Radio(value: 1, groupValue: groupValue,onChanged: (newValue){
                                        setState(() {
                                          groupValue = newValue;
                                          print(groupValue);
                                        });
                                      }),
                                    ],
                                  ),
                                ],
                              ):Container(height: 0,)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: signMeUp,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF007EF4),
                                Color(0xFF2A75BC)
                              ]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Register(userType: widget.userType=='patient'?'doctor':'patient',)));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              widget.userType=='patient'?'Sign up as Doctor':'Sign up as Patient',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an Account? ",
                              style: TextStyle(fontSize: 17),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LogIn()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 17,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
      ),
    );
  }
}

