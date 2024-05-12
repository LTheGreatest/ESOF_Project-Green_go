import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUserAchievements {
  static final CollectionReference userAchievementsCollection = FirebaseFirestore.instance.collection("user_achievements");

  Future getUserAchivements(String uid) async {
    return await userAchievementsCollection.doc(uid).get();
  }
  
  Future deleteUserAchievement(String userId, String achievementId) async {
    DocumentSnapshot doc = await userAchievementsCollection.doc(userId).get();
    List<dynamic> achievements = doc['achievements'];
    achievements.remove(achievementId);
    return await userAchievementsCollection.doc(userId).update({'achievements': achievements});
  }
  Future addUserAchievement(String userId, String achievementId) async {
    DocumentSnapshot doc = await userAchievementsCollection.doc(userId).get();
    List<dynamic> achievements = doc['achievements'];
    achievements.add(achievementId);
    return await userAchievementsCollection.doc(userId).update({'achievements': achievements});
  }
  Future addCompletedAchievement(String userId, String achievementId) async {
    DocumentSnapshot doc = await userAchievementsCollection.doc(userId).get();
    Map<String, Timestamp> completedAchievements = doc['completedAchievements'];
    completedAchievements[achievementId] = Timestamp.now();
    return await userAchievementsCollection.doc(userId).update({'completedAchievements': completedAchievements});
  }
}