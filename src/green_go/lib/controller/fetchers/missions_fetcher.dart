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
  Future<List<MissionsModel>> getUserMissions(String userId) async {
    await dbUser.getUserMissions(userId).then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          missions.add(MissionsModel(docSnapshot["title"], docSnapshot["description"], docSnapshot["frequency"], docSnapshot["points"], docSnapshot["types"]));
        } catch (e) {
          if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
    });
    return missions;
  }
}
