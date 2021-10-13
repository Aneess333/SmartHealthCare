class RatingModel{
  dynamic rating;
  String docName;
  String review;
  String satisfaction;
  String patient;
  RatingModel({this.patient,this.rating,this.docName,this.review,this.satisfaction});
  factory RatingModel.fromJson(Map<String, dynamic>map)=> RatingModel(
      rating: map['rating'],
    docName: map['docName'],
    review: map['review'],
    satisfaction: map['satisfaction'],
    patient: map['patient']
  );
  Map<String, dynamic> toMap()=>{
    'rating' : rating,
    'docName': docName,
    'review' : review,
    'satisfaction' : satisfaction,
    'patient' : patient
  };
}