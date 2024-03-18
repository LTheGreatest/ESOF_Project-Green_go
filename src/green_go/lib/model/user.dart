
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String username = "";
  String uid = "";
  int points = 0;

  String password = "";
  String email = "";

  User(String uid, String username, int points, String password, String email){
      this.uid = uid;
      this.username = username;
      this.points = points;
      this.email = email;
      this.password = password;
  }
}