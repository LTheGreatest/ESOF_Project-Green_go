import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pair/pair.dart';
import 'package:green_go/controller/database/database_achievements.dart';
import 'package:green_go/controller/database/database_user_achievements.dart';
import 'package:green_go/model/achievements_model.dart';

class AchievementsFetcher {
  DataBaseAchievements db = DataBaseAchievements();
  DataBaseUserAchievements dbUser = DataBaseUserAchievements();
  List<AchievementsModel> achievements = [];
  List<Pair<String, AchievementsModel>> achievementsId = [];
  List<Pair<AchievementsModel, Timestamp>> completedAchievements = [];
  List<Pair<AchievementsModel, int>> uncompletedAchievements= [];

  void setDB(DataBaseAchievements newDB) {
    db = newDB;
  }
  void setDBUser(DataBaseUserAchievements newDBUser) {
    dbUser = newDBUser;
  }

  Future<List<AchievementsModel>> getAllAchievements() async {
    //gets all achievements available at the firebase firestore database
    await db.getAllAchievements().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          String uid = docSnapshot.id;
          String name = docSnapshot["name"];
          String description = docSnapshot["description"];
          List<dynamic> types = docSnapshot["types"];

          achievements.add(AchievementsModel(name, description, types));
          achievementsId.add(Pair(uid, AchievementsModel(name, description, types)));
        } catch (e) {
          if (kDebugMode) {
            print("Failed with error '${e.toString()}'");
          }
        }
      }
    });
    return achievements;
  }

  Future<List<Pair<AchievementsModel, Timestamp>>> getCompleteAchievements(String userId) async {
    await getAllAchievements();
    await dbUser.getUserAchievements(userId).then((docSnapshot) {
      try {
        Map<String, dynamic> completed = docSnapshot["completedAchievements"];
        completed.forEach((key, value) {
          for (int i = 0; i < achievementsId.length; i++) {
            if (achievementsId[i].key == key) {
              String name = achievementsId[i].value.name;
              String description = achievementsId[i].value.description;
              List<dynamic> types = achievementsId[i].value.types;

              completedAchievements.add(Pair(AchievementsModel(name, description, types), value));
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
    return completedAchievements;
  }
  Future<List<Pair<AchievementsModel, int>>> getUncompletedAchievements(String userId) async {
    await getAllAchievements();
    await dbUser.getUserAchievements(userId).then((docSnapshot) {
      try {
        Map<String, int> uncompleted = docSnapshot["achievements"];
        uncompleted.forEach((key, value) {
          for (int i = 0; i < achievementsId.length; i++) {
            if (achievementsId[i].key == key) {
              String name = achievementsId[i].value.name;
              String description = achievementsId[i].value.description;
              List<dynamic> types = achievementsId[i].value.types;

              uncompletedAchievements.add(Pair(AchievementsModel(name, description, types), value));
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
    return uncompletedAchievements;
  }
  Future<Map<String, dynamic>> getCompletedAchievementsId(String userId) async{
    Map<String, dynamic> completedAchievementsId={};
    await dbUser.getUserAchievements(userId).then((querySnapshot) {
      completedAchievementsId= querySnapshot['completedAchievements'];
    });
    return completedAchievementsId;
  }
  Future<Map<String, dynamic>> getUncompletedAchievementsId(String userId) async {
    Map<String, dynamic> uncompletedAchievementsId = {};
    await dbUser.getUserAchievements(userId).then((querySnapshot) {
      uncompletedAchievementsId = querySnapshot['achievements'];
    });
    return uncompletedAchievementsId;
  }
}
