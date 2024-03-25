import 'package:green_go/controller/database/database_users.dart';

class LeaderboardModel{
  DataBaseUsers db = DataBaseUsers();
  List<List<String>> userScore = [];

  Future<List<List<String>>> getDataForLeaderboard() async{
    await db.getAllData().then((querySnapshot) {
      for(var docSnapshot in querySnapshot.docs){
          userScore.add([docSnapshot['username'], docSnapshot["points"]]);
      }
    }
    );
    return userScore;
  }
}
