import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/controller/verifiers/achievement_verifier.dart';
import 'package:green_go/model/user_model.dart';


class DataBaseUsers {
  static final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  static final CollectionReference userMissionsCollection = FirebaseFirestore.instance.collection("user_missions");
  static final CollectionReference userAchievementsCollection = FirebaseFirestore.instance.collection("user_achievements");
  AchievementVerifier achievementVerifier = AchievementVerifier();

  Future addUser(UserModel user) async {
    //adds a new user to the database (when a new user signup)
    await userMissionsCollection.doc(user.uid).set({
      'missions': [],
      'completedMissions': {},
    });
    await userAchievementsCollection.doc(user.uid).set({
      'achievements': {},
      'completedAchievements': {},
    });
    await achievementVerifier.initializeAllAchievements(user.uid);

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
  Future updateUserPoints(String uid, int points) async {
    //update de user's points in the database
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    userCollection.doc(uid).update({'totalPoints': doc['totalPoints'] + points, 'weeklyPoints': doc['weeklyPoints'] + points,
                                    'monthlyPoints': doc['monthlyPoints'] + points, 'streak': doc['streak'] + points});
  }
  Future updateUserGoal(String uid, int goal) async {
    //updates the user's point goal in the database
    return await userCollection.doc(uid).update({'goal': goal});
  }

  Future updateUserProfile(String uid, String username, String nationality, String job, DateTime birthDate) async {
    //updates the user's profile (all the important fields) in the database
    return await userCollection.doc(uid).update({'username': username,  'nationality': nationality, 'job': job, 'birthDate': birthDate});
  }
  Future updateUserPicture(String uid, String photoUrl) async {
    //updates the user's picture in the database
    return await userCollection.doc(uid).update({'photoUrl': photoUrl});
  }
  Future getAllData() async {
    //gets all the users data
    return await userCollection.get();
  }
  Future<DocumentSnapshot<Object?>> getUserData(String uid) async {
    //gets a specific user data
    return await userCollection.doc(uid).get();
  }
  void deleteUser(String uid) {
    //deletes a user from the system
    userMissionsCollection.doc(uid).delete();
    userCollection.doc(uid).delete();
    userAchievementsCollection.doc(uid).delete();
  }
}
