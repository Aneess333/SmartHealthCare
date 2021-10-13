class DoctorModel{
  dynamic docEmail;
  dynamic name;
  dynamic speciality;
  dynamic qualification;
  dynamic city;
  dynamic experience;
  dynamic fee;
  dynamic hospitalName;
  dynamic patientSatisfaction;
  dynamic waitTime;
  dynamic aboutDoc;
  dynamic rating;
  dynamic reviewsNum;
  String startTime;
  String endTime;
  String docMobileNumber;
  String userType;
  String docPmc;
  String appointmentLead;
  DoctorModel({this.appointmentLead,this.docPmc,this.userType,this.docMobileNumber,this.docEmail,this.endTime,this.startTime,this.reviewsNum,this.rating,this.name,this.speciality,this.qualification,this.city,this.experience,this.fee,this.aboutDoc,this.hospitalName,this.patientSatisfaction,this.waitTime});
  factory DoctorModel.fromJson(Map<String, dynamic>map)=>DoctorModel(
    name: map['name'],
    speciality: map['speciality'],
    qualification: map['qualification'],
    city: map['city'],
    experience: map['experiance'],
    fee: map['fee'],
    hospitalName: map['hospitalName'],
    patientSatisfaction: map['patientSatisfication'],
    waitTime: map['waitTime'],
    aboutDoc: map['aboutDoc'],
    rating: map['rating'],
    reviewsNum: map['reviewsNum'],
    startTime: map['startTime'],
    endTime: map['endTime'],
    docEmail: map['email'],
    docMobileNumber: map['mobileNumber'],
    userType : map['userType'],
    docPmc : map['pmc'],
    appointmentLead: map['appointmentsLead']
  );
  Map<String, dynamic> toMap()=>{
    'name' : name,
    'speciality': speciality,
    'qualification' : qualification,
    'city' : city,
    'experiance' : experience,
    'fee':fee,
    'hospitalName':hospitalName,
    'patientSatisfication': patientSatisfaction,
    'waitTime':waitTime,
    'aboutDoc' : aboutDoc,
    'rating' : rating,
    'reviewsNum': reviewsNum,
    'startTime' : startTime,
    'endTime' : endTime,
    'email' : docEmail,
    'mobileNumber' : docMobileNumber,
    'userType' : userType,
    'pmc' : docPmc,
    'appointmentsLead' : appointmentLead
  };
}