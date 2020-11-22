import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:manipalleaks/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var imageUrl;
  //create user object from FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  String error = '';
  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sign in with email/pass
  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          error = "Enter A Valid Email-Id";
          // print("Enter A Valid Email-Id");
          break;
        case 'ERROR_WRONG_PASSWORD':
          error = "Incorrect Password";
          // print("Incorrect Password");
          break;
        case 'ERROR_USER_NOT_FOUND':
          error = "User Not Found";
          // print("User Not Found");
          break;
        case 'ERROR_USER_DISABLED':
          error = "User diasbled";
          // print("User diasbled");
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          error = "Too many requests";
          // print("Too many requests");
          break;
        default:
          error = "Unknown error";
          // print("Unknown error");
          break;
      }
      return error;
    }
  }

  // var initialEvents = {
  //   '${DateTime.utc(2020, 8, 3, 12)}': [
  //     'Revaluation Starts\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 12, 12)}': [
  //     'Bakri Eid\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 13, 12)}': [
  //     'Monday Timetable\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 14, 12)}': [
  //     'Saturday Timetable\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 15, 12)}': [
  //     'Independence Day\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 26, 12)}': [
  //     'Class Committee Meeting\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 27, 12)}': [
  //     'Class Committee Meeting\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 8, 28, 12)}': [
  //     'Class Committee Meeting\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 1, 3, 12)}': [
  //     'Event Semester Classes Start\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 1, 8, 12)}': [
  //     'Make Up Exams Result\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 1, 26, 12)}': [
  //     'Republic Day\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 2, 14, 12)}': [
  //     'First Sessional\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 2, 17, 12)}': [
  //     'First Sessional\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 2, 18, 12)}': [
  //     'First Sessional\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 4, 12)}': [
  //     'Revels\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 5, 12)}': [
  //     'Revels\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 6, 12)}': [
  //     'Revels\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 7, 12)}': [
  //     'Revels\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 20, 12)}': [
  //     'Second Sessional\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 23, 12)}': [
  //     'Second Sessional\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 24, 12)}': [
  //     'Second Sessional\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 3, 30, 12)}': [
  //     'Utsav\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 4, 1, 12)}': [
  //     'Utsav\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 4, 2, 12)}': [
  //     'Utsav\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 4, 3, 12)}': [
  //     'Utsav\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 4, 4, 12)}': [
  //     'Utsav\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 4, 22, 12)}': [
  //     'End Semester Exam Starts\r12:00 P.M\rNo Details Available'
  //   ],
  //   '${DateTime.utc(2020, 5, 13, 12)}': [
  //     'End Semester Exam Results\r12:00 P.M\rNo Details Available'
  //   ],
  // };
  //register with email/pass
  Future register(String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      imageUrl =
          'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';

      Firestore.instance.collection('/users').document(user.uid).setData({
        'uid': user.uid,
        'email': email,
        'name': name,
        // 'events': initialEvents,
        'imageUrl': imageUrl
      });
      return _userFromFirebaseUser(user);
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_WEAK_PASSWORD':
          error = "Enter a Stronger Password";
          break;
        case 'ERROR_INVALID_EMAIL':
          error = "Please Enter a Valid Email";
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          error = "Email is already in Use";
          break;
        default:
          error = "Unknown Error Occured";
          break;
      }
      return error;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
