class UserModel{
  dynamic name;
  dynamic city;
  dynamic mobileNumber;
  dynamic email;
  dynamic userType;
  UserModel({this.userType,this.city,this.email,this.name,this.mobileNumber});
  factory UserModel.fromJson(Map<String, dynamic>map)=>UserModel(
      userType: map['userType'],
      city: map['city'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      name: map['name']
  );
  Map<String, dynamic> toMap()=>{
    'name' : name,
    'email' : email,
    'mobileNumber' : mobileNumber,
    'city' : city,
    'userType' : userType
  };
}