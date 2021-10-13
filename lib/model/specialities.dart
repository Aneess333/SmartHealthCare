class SpecialitiesModel{
  dynamic speciality;
  SpecialitiesModel({this.speciality});
  factory SpecialitiesModel.fromJson(Map<String, dynamic>map)=> SpecialitiesModel(
    speciality: map['speciality']
  );
  Map<String, dynamic> toMap()=>{
    'speciality' : speciality
  };
}