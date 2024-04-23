import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/model/user_model.dart';

class DataBaseUsers {
  static final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future addUser(UserModel user) async {
    await FirebaseFirestore.instance.collection("user_missions").doc(user.uid).set({
      'missions': [],
      'completedMissions': {},
    });
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
    userCollection.doc(uid).delete();
  }
}
