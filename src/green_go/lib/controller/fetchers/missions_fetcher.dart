import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:green_go/controller/database/database_missions.dart';
import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/model/missions_model.dart';

class MissionsFetcher {
  DataBaseMissions db = DataBaseMissions();
  DataBaseUserMissions dbUser = DataBaseUserMissions();
  List<MissionsModel> missions = [];

  void setDB(DataBaseMissions newDB) {
    db = newDB;
  }
  void setDBUser(DataBaseUserMissions newDBUser) {
    dbUser = newDBUser;
  }
  Future<List<MissionsModel>> getAllMissions() async {
    //gets all missions available at the firebase firestore database
    await db.getAllMissions().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          String title = docSnapshot["title"];
          String description = docSnapshot["description"];
          String frequency = docSnapshot["frequency"];
          int points = docSnapshot["points"];
          List<dynamic> types = docSnapshot["types"];

          missions.add(MissionsModel(title, description, frequency, types, points));
        } catch (e) {
          if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
    });
    return missions;
  }

  Future<Map<String, MissionsModel>> getAllMissionsWithID() async {
    Map<String, MissionsModel> missionsWithID = {};
    //gets all missions available at the firebase firestore database
    await db.getAllMissions().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          String title = docSnapshot["title"];
          String description = docSnapshot["description"];
          String frequency = docSnapshot["frequency"];
          int points = docSnapshot["points"];
          List<dynamic> types = docSnapshot["types"];
          MissionsModel missionsModel = MissionsModel(title, description, frequency, types, points);
          missionsWithID[docSnapshot.id]=missionsModel;
          //missionsWithID.addEntries({docSnapshot.id : missionsModel} as Iterable<MapEntry<String, MissionsModel>>);
        } catch (e) {
          if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
    });
    return missionsWithID;
  }

  Future<Map<String, MissionsModel>> getUserMissions(String userId) async {
    Map<String, MissionsModel> missions = await getAllMissionsWithID();
    Map<String, MissionsModel> completedMissions={};
    //gets all the mission that the user completed
    await dbUser.getUserMissions(userId).then((querySnapshot) {
      Map<String, dynamic> completedMission = querySnapshot["completedMissions"];

      
      for (MapEntry<String,dynamic> mission in completedMission.entries) {
        completedMissions[mission.key]=missions[mission.key]!;
      }
      
    });
    return completedMissions;
  }
  Future<Timestamp> getTimeOfMission(String missionId , String userId) async {
    Timestamp time;
    DocumentSnapshot querySnapshot = await dbUser.getUserMissions(userId);
    Map<String, dynamic> completedMission = querySnapshot["completedMissions"];
    time=completedMission[missionId]!;
    
    return time;
  }
}
