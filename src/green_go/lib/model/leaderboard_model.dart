import 'package:firebase_core/firebase_core.dart';
import 'package:green_go/controller/database/database_users.dart';

class LeaderboardModel{
  DataBaseUsers db = DataBaseUsers();
  List<List<dynamic>> userScore = [];

  Future<List<List<dynamic>>> getDataForLeaderboard() async{
    await db.getAllData().then((querySnapshot) {
      for(var docSnapshot in querySnapshot.docs){
        Map<String, dynamic> data = docSnapshot.data();
        try{
          userScore.add([data['username'],data['points']]);
        } catch(e) {
          print("Failed with error '${e.toString()}'");
        }
      }
    }
    );
    return userScore;
  }
}
