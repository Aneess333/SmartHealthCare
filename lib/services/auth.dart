import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthealth_care/model/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      if(user.emailVerified){
        return user.uid;
      }
      else{
        return 'Email not verified';
      }
    } catch (e) {
      if (e.code == 'ERROR_INVALID_EMAIL' ||
          e.code == 'ERROR_WRONG_PASSWORD' ||
          e.code == 'ERROR_USER_NOT_FOUND') {
        return 'Invalid email or password';
      } else {
        return null;
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email is Already in use';
      } else {
        return null;
      }
    }
  }
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {}
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
