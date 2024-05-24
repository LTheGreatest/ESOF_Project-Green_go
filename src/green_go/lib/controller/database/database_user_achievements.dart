import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUserAchievements {
  static final CollectionReference userAchievementsCollection = FirebaseFirestore.instance.collection("user_achievements");

  Future getUserAchievements(String uid) async {
    //gets the achievements of a given user
    return await userAchievementsCollection.doc(uid).get();
  }

  Future deleteUserAchievement(String userId, String achievementId) async {
    //Deletes a achivements from the user achievements section (because the achievement will be transferred to the completed achievements)
    DocumentSnapshot doc = await userAchievementsCollection.doc(userId).get();
    Map<String, int> achievements = Map<String, int>.from(doc['achievements']);
    achievements.remove(achievementId);
    return await userAchievementsCollection.doc(userId).update({'achievements': achievements});
  }
  Future addUserAchievement(String userId, String achievementId, int points) async {
    //Adds a achievements to the user achievements section
    DocumentSnapshot doc = await userAchievementsCollection.doc(userId).get();
    Map<String, dynamic> achievements = doc['achievements'];
    achievements[achievementId] = points;
    return await userAchievementsCollection.doc(userId).update({'achievements': achievements});
  }
  Future addCompletedAchievement(String userId, String achievementId) async {
    //Adds a completed achievement to the user completed achievements section
    DocumentSnapshot doc = await userAchievementsCollection.doc(userId).get();
    Map<String, dynamic> completedAchievements = doc['completedAchievements'];
    Map<String, Timestamp> timestampMap = Map<String, Timestamp>.from(completedAchievements);
    timestampMap[achievementId] = Timestamp.now();
    return await userAchievementsCollection.doc(userId).update({'completedAchievements': timestampMap});
  }

}