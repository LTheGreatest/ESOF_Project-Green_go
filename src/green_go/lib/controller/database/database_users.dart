import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/controller/database/database_achievements.dart';
import 'package:green_go/model/user_model.dart';
import 'package:pair/pair.dart';

import '../../model/achievements_model.dart';
import '../fetchers/achievements_fetcher.dart';
import 'database_user_achievements.dart';

class DataBaseUsers {
  static final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  static final CollectionReference userMissionsCollection = FirebaseFirestore.instance.collection("user_missions");
  static final CollectionReference userAchievementsCollection = FirebaseFirestore.instance.collection("user_achievements");
  AchievementsFetcher achievementsFetcher = AchievementsFetcher();
  DataBaseUserAchievements dbUserAch = DataBaseUserAchievements();
  late List<Pair<String, AchievementsModel>> achievementsPair;

  String getAchievementType(List<dynamic> types){
    for(dynamic type in types){
      if(type is String){
        return type;
      }
    }
    return "";
  }


  Future<void> addAchievements(String userId) async {
    await achievementsFetcher.getAllAchievements();
    achievementsPair =  achievementsFetcher.achievementsId;
    Map<String, int> missionAchievements= {};
    Map<String, int> loginAchievements = {};
    Map<String, int> tripAchievements = {};
    for (final achievement in achievementsPair) {
      String achievementType = getAchievementType(achievement.value.types);
      if(achievementType == "NumberMissions") {
        missionAchievements[achievement.key] = 0;
      } else if (achievementType == "NumberTrips") {
        tripAchievements[achievement.key] = 0;
      } else if (achievementType == "NumberLogins") {
        loginAchievements[achievement.key] = 0;
      }
    }
    await dbUserAch.addUserAchievement(userId, missionAchievements);
    await dbUserAch.addUserAchievement(userId, loginAchievements);
    await dbUserAch.addUserAchievement(userId, tripAchievements);
  }

  Future addUser(UserModel user) async {
    await userMissionsCollection.doc(user.uid).set({
      'missions': [],
      'completedMissions': {},
    });
    await userAchievementsCollection.doc(user.uid).set({
      'achievements': [],
      'completedAchievements': {},
    });
    await addAchievements(user.uid);

    return await userCollection.doc(user.uid).set({
      'username': user.username,
      'totalPoints': user.totalPoints,
      'weeklyPoints': user.weeklyPoints,
      'monthlyPoints': user.monthlyPoints,
      'streak': user.streak,
      'goal': user.goal,
      'firstTime': user.firstTime,
      'nationality': user.nationality,
      'job': user.job,
      'birthDate': user.birthDate,
      'photoUrl': user.photoUrl,
    });
  }
  Future updateUsername(String uid, String username) async {
     return await userCollection.doc(uid).set({
      'username': username
     });
  }
  Future updateUserPoints(String uid, int points) async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    userCollection.doc(uid).update({'totalPoints': doc['totalPoints'] + points, 'weeklyPoints': doc['weeklyPoints'] + points,
                                    'monthlyPoints': doc['monthlyPoints'] + points, 'streak': doc['streak'] + points});
  }
  Future updateUserGoal(String uid, int goal) async {
    return await userCollection.doc(uid).update({'goal': goal});
  }
  Future updateUserFirstTime(String uid, bool firstTime) async {
    return await userCollection.doc(uid).update({'firstTime': firstTime});
  }
  Future updateUserProfile(String uid, String username, String nationality, String job, DateTime birthDate) async {
    return await userCollection.doc(uid).update({'username': username,  'nationality': nationality, 'job': job, 'birthDate': birthDate});
  }
  Future updateUserPicture(String uid, String photoUrl) async {
    return await userCollection.doc(uid).update({'photoUrl': photoUrl});
  }
  Future resetWeeklyPoints() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    var allUsers = querySnapshot.docs;
    for (var user in allUsers) {
      user.reference.update({'weeklyPoints': 0});
    }
  }
  Future resetMonthlyPoints() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    var allUsers = querySnapshot.docs;
    for (var user in allUsers) {
      user.reference.update({'monthlyPoints': 0});
    }
  }
  Future getAllData() async {
    return await userCollection.get();
  }
  Future<DocumentSnapshot<Object?>> getUserData(String uid) async {
    return await userCollection.doc(uid).get();
  }
  void deleteUser(String uid) {
    userMissionsCollection.doc(uid).delete();
    userCollection.doc(uid).delete();
  }
}
