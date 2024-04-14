import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';

class UserFetcher {
  DataBaseUsers db = DataBaseUsers();
  List<UserModel> users = [];

  Future<List<UserModel>> getDataForLeaderboard() async {
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
          print("Failed with error '${e.toString()}'");
        }
      }
    });
    return users;
  }

  Future<UserModel> getCurrentUserData() async{
    UserModel user = UserModel(AuthService().getCurrentUser()!.uid, "notDefined");
    await db.getUserData(AuthService().getCurrentUser()!.uid).then((querySnapshot){
        try{
          String username = querySnapshot['username'] ;

          String photoUrl = querySnapshot['photoUrl'];                                     
          String nationality = querySnapshot['nationality'];                          
          String job = querySnapshot['job']; 
          DateTime birthDate = querySnapshot['birthDate'];

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
          user.birthDate = birthDate;
          user.totalPoints = totalPoints;
          user.weeklyPoints = weeklyPoints;
          user.monthlyPoints = monthlyPoints;
          user.streak = streak;
          user.goal = goal;
          user.firstTime = firstTime;

        } catch (e){
          print("Failed with error '${e.toString()}'");
        }
    } );
      return user;
  }
}
