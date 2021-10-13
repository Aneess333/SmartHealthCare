import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/model/appoint_model.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/medicineModel.dart';
import 'package:smarthealth_care/model/prescription_model.dart';
import 'package:smarthealth_care/model/user.dart';

class DatabaseMethods {
  getUsersByName(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .get();
  }

  Future<dynamic> getSpecialities() async {
    try{
      var data = await  FirebaseFirestore.instance
          .collection('fields')
          .get();
      if(data.size>0){
        return data.docs;
      }
      return 'No Specialities found!';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getUpcomingAppointments(String email, String date)async{
    try{
      var data = await FirebaseFirestore.instance
          .collection('Appointments')
          .where('docEmail',isEqualTo: email)
      .where('appointmentStatus',isEqualTo: 'Pending')
          .where('date', isEqualTo: date)
      .orderBy('id',descending: false)
          .get();
      if(data.size>0){
        return data.docs;
      }
      return 'No appointments found';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getCompletedAppointments(String email) async {
    try{
      var data = await FirebaseFirestore.instance
          .collection('Appointments')
          .where('docEmail',isEqualTo: email)
          .where('appointmentStatus',isEqualTo: 'Completed')
          .orderBy('endTime',descending: true)
          .get();
      if(data.size>0){
        return data.docs;
      }
      return 'No appointments found';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getAppointments(String email) async {
    try{
      var data = await FirebaseFirestore.instance
      .collection('Appointments')
          .where('docEmail',isEqualTo: email)
          .get();
      if(data.size>0){
        return data.docs;
      }
      else{
        data = await FirebaseFirestore.instance
            .collection('Appointments')
            .where('patientEmail',isEqualTo: email)
            .get();
      }
      if(data.size>0){
        return data.docs;
      }
      return 'No appointments found';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getRatings(String docName) async {
    try{
      var data = await FirebaseFirestore.instance
          .collection('Ratings')
      .where('docName',isEqualTo: docName)
          .get();
      if(data.size>0){
        return data.docs;
      }
      return 'no rating';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getDoctorsWithSpeciality(String speciality,bool nearby,UserModel userModel) async {
    try{
      var data;
      if(nearby){
        print(userModel.city);
        data = await FirebaseFirestore.instance
            .collection('doctors')
            .where('speciality',isEqualTo: speciality)
            .where('city',isEqualTo: userModel.city)
            .get();
      }
      else{
        data = await FirebaseFirestore.instance
            .collection('doctors')
            .where('speciality',isEqualTo: speciality)
            .get();
      }

      if(data.size>0){
        return data.docs;
      }
      return 'No doctors found related to $speciality !';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getUsersByEmail(String email) async {
    try{
      var data;
        data = await FirebaseFirestore.instance
            .collection('users')
            .where('email',isEqualTo: email)
            .get();

      if(data.size>0){
        return data.docs;
      }
      else{
        data = await FirebaseFirestore.instance
            .collection('doctors')
            .where('email',isEqualTo: email)
            .get();
      }
      if(data.size>0){
        return data.docs;
      }
      return 'No user found';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> givePrescription(PrescriptionModel prescriptionModel,List<MedicineModel> medicineModel,String id)async{
    try{
      await FirebaseFirestore.instance
          .collection('Prescriptions')
          .doc(id)
          .set(prescriptionModel.toMap());
      for(int i = 0;i<medicineModel.length;i++){
        await FirebaseFirestore.instance
            .collection('Prescriptions')
            .doc(id)
            .collection('medicines')
            .doc()
            .set(medicineModel[i].toMap());
      }
      return true;
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> bookAppointment(AppointmentModels appointmentModel) async{
    try{
      await FirebaseFirestore.instance
          .collection('Appointments')
          .doc()
          .set(appointmentModel.toMap());
      return true;
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  Future getLastMessage(String chatRoomId, String username) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
    .collection('chats')
    .orderBy('timeStamp',descending: true)
    .limit(1)
      .get();
  }

  getConversationMessages(String chatRoomId,String username) async {
    QuerySnapshot chats = await FirebaseFirestore.instance
    .collection('ChatRoom')
    .doc(chatRoomId)
    .collection('chats')
    .where('sendBy', isEqualTo: username)
    .where('read',isEqualTo: 'unread').get();
    print(chats.docs.length);
    for(int i=0; i<chats.docs.length;i++){
      FirebaseFirestore.instance.collection('ChatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(chats.docs[i].id)
          .update({'read': 'read'});
    }
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timeStamp')
        .snapshots();
  }
  Future<dynamic> getPrescriptions(String id) async {
    try{
      var data;
      data = await FirebaseFirestore.instance
          .collection('Prescriptions')
          .doc(id)
      .collection('medicines')
      .get();
      if(data.size>0){
        return data.docs;
      }
      return 'No Prescription found';
    }
    on FirebaseException catch(e){
      return e.message;
    }
  }
  Future<dynamic> getNotifications(String name)async{
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: name)
        .get();
    // print('${querySnapshot.docs[0].id}sddnsk');
    // String userName;

  }
  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap);
  }
  uploadDocInfo(userMap) {
    FirebaseFirestore.instance.collection('doctors').add(userMap);
  }
  updateUserInfo(UserModel userMap, String email) async {
    var doc_ref = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
    FirebaseFirestore.instance.collection('users').doc(doc_ref.docs[0].id).set({
      'name' : userMap.name,
      'email' : userMap.email,
      'mobileNumber' : userMap.mobileNumber,
      'city' : userMap.city,
      'userType' : userMap.userType
    });
  }

  createChatRoom(String chatroomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatroomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
