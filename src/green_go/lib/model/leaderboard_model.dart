
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/controller/database/database_users.dart';

class LeaderboardModel{
  DataBaseUsers db = DataBaseUsers();
  List<List<String>> userScore = [];

  LeaderboardModel(){
    db.getAllData().then((querySnapshot) {
      for(var docSnapshot in querySnapshot.docs){
          userScore.add([docSnapshot['username'], docSnapshot["points"]]);
      }
    }
    );
  }

  List<List<String>> getUserScore(){
    return userScore;
  }

}