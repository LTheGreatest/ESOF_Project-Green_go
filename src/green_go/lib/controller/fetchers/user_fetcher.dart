import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';

class UserFetcher {
  DataBaseUsers db = DataBaseUsers();
  List<UserModel> users = [];
  late AuthService auth = AuthService();

  void setDB(DataBaseUsers newDB){
    db = newDB;
  }
  void setAuth(AuthService newAuth){
    auth = newAuth;
  }
  Future<List<UserModel>> getDataForLeaderboard() async {
    //gets all user information to use in the leaderboard
    await db.getAllData().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data();
        try {
          String username = data['username'];
          int totalPoints = data['totalPoints'];
          int weeklyPoints = data['weeklyPoints'];
          int monthlyPoints = data['monthlyPoints'];
          UserModel user = UserModel(docSnapshot.id, username);
          user.totalPoints = totalPoints;
          user.weeklyPoints = weeklyPoints;
          user.monthlyPoints = monthlyPoints;
          users.add(user);
        } catch(e) {
          if (kDebugMode) {
            print("Failed with error '${e.toString()}'");
          }
        }
      }
    });
    return users;
  }
  Future<UserModel> getCurrentUserData() async {
    //gets the current user data (user that is currently logged in)
    UserModel user = UserModel(auth.getCurrentUser()!.uid, "notDefined");
    dynamic querySnapshot;
    await db.getUserData(auth.getCurrentUser()!.uid).then((value) => querySnapshot = value);
        try {
          String username = querySnapshot['username'] ;
          String photoUrl = querySnapshot['photoUrl'];                                     
          String nationality = querySnapshot['nationality'];                          
          String job = querySnapshot['job']; 
          Timestamp birthDate = querySnapshot['birthDate'];

          int totalPoints = querySnapshot['totalPoints'];
          int weeklyPoints = querySnapshot['weeklyPoints'];
          int monthlyPoints = querySnapshot['monthlyPoints'];
          int streak = querySnapshot['streak'];
          int goal = querySnapshot['goal'];

          bool firstTime = querySnapshot['firstTime'];

          user.username = username;
          user.photoUrl = photoUrl;
          user.nationality = nationality;
          user.job = job;
          user.birthDate = birthDate.toDate();
          user.totalPoints = totalPoints;
          user.weeklyPoints = weeklyPoints;
          user.monthlyPoints = monthlyPoints;
          user.streak = streak;
          user.goal = goal;
          user.firstTime = firstTime;

        } catch (e) {
          if (kDebugMode) {
            print("Failed with error '${e.toString()}'");
          }
        }
      return user;
  }
}
