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
  List<Pair<AchievementsModel, int>> uncompletedAchievements = [];

  void setDB(DataBaseAchievements newDB) {
    db = newDB;
  }

  void setDBUser(DataBaseUserAchievements newDBUser) {
    dbUser = newDBUser;
  }

  void setAchievementsID(List<Pair<String, AchievementsModel>> newAchivementsID){
    achievementsId = newAchivementsID;
  }

  List<Pair<String, AchievementsModel>> getAchievementsID(){
    return achievementsId;
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
    //gets the achievements that the user completed
    completedAchievements.clear();

    await getAllAchievements();

    await dbUser.getUserAchievements(userId).then((docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> completed = docSnapshot["completedAchievements"];
        completed.forEach((key, value) {
          for (var achievement in achievementsId) {
            if (achievement.key == key) {
              completedAchievements.add(Pair(achievement.value, value));
              break;
            }
          }
        });
      }
    }).catchError((e) {
      if (kDebugMode) {
        print("Failed with error '${e.toString()}'");
      }
    });

    return completedAchievements;
  }

  Future<List<Pair<AchievementsModel, int>>> getUncompletedAchievements(String userId) async {
    //gets the achievements that the user didn't completed
    uncompletedAchievements.clear();

    await getAllAchievements();

    await dbUser.getUserAchievements(userId).then((docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> uncompleted = docSnapshot["achievements"];
        uncompleted.forEach((key, value) {
          for (var achievement in achievementsId) {
            if (achievement.key == key) {
              uncompletedAchievements.add(Pair(achievement.value, value));
              break;
            }
          }
        });
      }
    }).catchError((e) {
      if (kDebugMode) {
        print("Failed with error '${e.toString()}'");
      }
    });

    return uncompletedAchievements;
  }

  Future<Map<String, dynamic>> getCompletedAchievementsId(String userId) async{
    //Gets the user's completed achievements ID
    Map<String, dynamic> completedAchievementsId={};
    await dbUser.getUserAchievements(userId).then((querySnapshot) {
      completedAchievementsId= querySnapshot['completedAchievements'];
    });
    return completedAchievementsId;
  }
  Future<Map<String, dynamic>> getUncompletedAchievementsId(String userId) async {
    //gets the user's uncompleted achievements ID
    Map<String, dynamic> uncompletedAchievementsId = {};
    await dbUser.getUserAchievements(userId).then((querySnapshot) {
      uncompletedAchievementsId = querySnapshot['achievements'];
    });
    return uncompletedAchievementsId;
  }
}
