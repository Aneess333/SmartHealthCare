class   MedicineModel{
  dynamic medicineName;
  dynamic days;
  dynamic beforeOrAfter;
  bool morning, evening, afternoon;
  MedicineModel({this.days,this.afternoon,this.beforeOrAfter,this.evening,this.medicineName,this.morning});
  factory MedicineModel.fromJson(Map<String, dynamic>map)=>MedicineModel(
      medicineName: map['medicineName'],
      days: map['days'],
    beforeOrAfter: map['beforeOrAfter'],
    morning: map['morning'],
    afternoon: map['afternoon'],
    evening: map['evening']
  );
  Map<String, dynamic> toMap()=>{
    'medicineName' : medicineName,
    'days' : days,
    'beforeOrAfter' : beforeOrAfter,
    'morning' : morning,
    'afternoon' : afternoon,
    'evening' : evening
  };
}