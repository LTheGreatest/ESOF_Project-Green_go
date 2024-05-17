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
    //gets all the mission that the user completed
    await dbUser.getUserAchivements(userId).then((docSnapshot) {
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
  Future<Map<String,dynamic>> getCompletedAchievementsId(String userId) async{
    Map<String,dynamic> completedAchievementsId={};
    await dbUser.getUserAchivements(userId).then((querySnapshot) {
      completedAchievementsId= querySnapshot['completedMissions'];
    });
    return completedAchievementsId;
  }

  Future<List<dynamic>> getAchievementsInProgress(String userId) async {
    List<dynamic> achievementsInProgress = [];

    // Get the document snapshot
    DocumentSnapshot<Map<String, dynamic>>? snapshot = await dbUser.getUserAchivements(userId);

    // Check if the snapshot is not null and contains the "achievements" field
    if (snapshot != null && snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey("achievements")) {
      // Access the "achievements" field
      achievementsInProgress = snapshot.data()!["achievements"];
    }

    return achievementsInProgress;
  }

  Future<List<Pair<AchievementsModel, Timestamp>>> getUncompletedAchievements(String userId) async {
    await getAllAchievements();

    // Get the completed achievements
    List<Pair<AchievementsModel, Timestamp>> completedAchievements = await getCompleteAchievements(userId);

    // Initialize an empty list to store uncompleted achievements
    List<Pair<AchievementsModel, Timestamp>> uncompletedAchievements = [];

    // Get the user's in-progress achievements
    List<dynamic> achievementsInProgress = await getAchievementsInProgress(userId);

    // Iterate through all achievements and filter out the completed ones
    for (int i = 0; i < achievementsId.length; i++) {
      String achievementId = achievementsId[i].key;
      bool isCompleted = false;

      // Check if the achievement is completed
      for (int j = 0; j < completedAchievements.length; j++) {
        if (achievementId == completedAchievements[j].key) {
          isCompleted = true;
          break;
        }
      }

      // If the achievement is not completed, check if it is in progress
      if (!isCompleted) {
        // Check if the achievement is already in progress
        bool isInProgress = achievementsInProgress.contains(achievementId);

        // If the achievement is not already in progress, add it to the list of uncompleted achievements
        if (!isInProgress) {
          String name = achievementsId[i].value.name;
          String description = achievementsId[i].value.description;
          List<dynamic> types = achievementsId[i].value.types;

          uncompletedAchievements.add(Pair(AchievementsModel(name, description, types), Timestamp.now()));
        }
      }
    }

    return uncompletedAchievements;
  }

}
