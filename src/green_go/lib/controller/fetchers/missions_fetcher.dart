import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pair/pair.dart';
import 'package:green_go/controller/database/database_missions.dart';
import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/model/missions_model.dart';

class MissionsFetcher {
  DataBaseMissions db = DataBaseMissions();
  DataBaseUserMissions dbUser = DataBaseUserMissions();
  List<MissionsModel> missions = [];
  List<Pair<String, MissionsModel>> missionsId = [];
  List<Pair<MissionsModel, Timestamp>> completedMissions = [];

  void setDB(DataBaseMissions newDB) {
    db = newDB;
  }
  void setDBUser(DataBaseUserMissions newDBUser) {
    dbUser = newDBUser;
  }
  void setMissionsID(List<Pair<String, MissionsModel>> newMissionsID){
    missionsId = newMissionsID;
  }
  Future<List<MissionsModel>> getAllMissions() async {
    //gets all missions available at the firebase firestore database
    await db.getAllMissions().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          String uid = docSnapshot.id;
          String title = docSnapshot["title"];
          String description = docSnapshot["description"];
          String frequency = docSnapshot["frequency"];
          int points = docSnapshot["points"];
          List<dynamic> types = docSnapshot["types"];

          missions.add(MissionsModel(title, description, frequency, types, points));
          missionsId.add(Pair(uid, MissionsModel(title, description, frequency, types, points)));
        } catch (e) {
          if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
    });
    return missions;
  }
  Future<List<Pair<MissionsModel, Timestamp>>> getCompleteMissions(String userId) async {
    await getAllMissions();
    //gets all the mission that the user completed
    await dbUser.getUserMissions(userId).then((docSnapshot) {
        try {
          Map<String, dynamic> completed = docSnapshot["completedMissions"];
          completed.forEach((key, value) {
            for (int i = 0; i < missionsId.length; i++) {
              if (missionsId[i].key == key) {
                String title = missionsId[i].value.title;
                String description = missionsId[i].value.description;
                String frequency = missionsId[i].value.frequency;
                List<dynamic> types = missionsId[i].value.types;
                int points = missionsId[i].value.points;

                completedMissions.add(Pair(MissionsModel(title, description, frequency, types, points), value));
              }
            }
          });
        } catch (e) {
          if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
    );
    return completedMissions;
  }
  Future<Map<String, dynamic>> getCompletedMissionsId(String userId) async {
    //gets the user's completed missions ID
    Map<String, dynamic> completedMissionsId = {};
    await dbUser.getUserMissions(userId).then((querySnapshot) {
      completedMissionsId= querySnapshot['completedMissions'];
    });
    return completedMissionsId;
  }

  Future<List<dynamic>> getMissionsInProgress(String userId) async{
    //gets the user's in progress missions 
    List<dynamic> missionsInProgress=[];
    await dbUser.getUserMissions(userId).then((querySnapshot) {
        missionsInProgress=querySnapshot['missions'];
    });
    return missionsInProgress;
  }
}
