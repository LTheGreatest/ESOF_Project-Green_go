

import 'package:flutter/foundation.dart';
import 'package:green_go/controller/database/database_missions.dart';
import 'package:green_go/model/missions_model.dart';

class MissionsFetcher {
  
  DataBaseMissions db = DataBaseMissions();
  List<MissionsModel> missions = [];

  Future<List<MissionsModel>> getAllMissions() async{
    await db.getAllData().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          String title = docSnapshot["title"];
          String description = docSnapshot["description"];
          int points = docSnapshot["points"];
          List<dynamic> types = docSnapshot["types"];

          MissionsModel mission = MissionsModel(title, description, types, points);
          missions.add(mission);

        } catch (e){
          if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
    });

    return missions;
  }


}