import 'package:flutter/material.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/user.dart';
class EditProfile extends StatefulWidget {
  final UserModel userModel;
  const EditProfile({Key key, this.userModel}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number(11 digit)';
    }
    return null;
  }
  bool isLoading = false;
  UserModel userModel = UserModel();
  DatabaseMethods databaseMethods = DatabaseMethods();
  updateData(){
    if(_updateFormKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      if(widget.userModel.userType == 'patient'){
        userModel.name = fullNameInputController.text;
        userModel.mobileNumber = mobileNumInputController.text;
        userModel.userType = 'patient';
        userModel.city = cityName;
        userModel.email = widget.userModel.email;
        databaseMethods.updateUserInfo(userModel, widget.userModel.email);
      }
    }
  }
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  TextEditingController fullNameInputController = TextEditingController();
  TextEditingController mobileNumInputController = TextEditingController();
  TextEditingController pmcInputController = TextEditingController();
  TextEditingController aboutDoctorInputController = TextEditingController();
  String speciality = 'Oral and Maxillofacial Surgeon';
  String cityName = 'Islamabad';
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
  @override
  void initState() {
    super.initState();
    fullNameInputController.text = widget.userModel.name;
    mobileNumInputController.text = widget.userModel.mobileNumber;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MainAppBar('Edit profile'),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _updateFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(clipBehavior: Clip.antiAlias,height: 100,width: 100,decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        border: Border.all(color: Colors.black),
                        color: Colors.black,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/images/male_doctor.png'),
                        ),
                      ), ),
                      Icon(Icons.camera_alt,size: 50,)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
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
                    InputDecoration(
                      labelText: 'Full Name',
                    ),
                    style: TextStyle(fontSize: 17)
                ),
                SizedBox(height: 20,),
                TextFormField(
                    validator: validateMobile,
                    controller: mobileNumInputController,
                    decoration:
                    InputDecoration(
                      labelText: 'Mobile Number',
                    ),
                    style: TextStyle(fontSize: 17)
                ),
                SizedBox(height: 20,),
                Row(
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
                ),
                SizedBox(height: 20,),
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
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: updateData,
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
                      'Update Profile',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
