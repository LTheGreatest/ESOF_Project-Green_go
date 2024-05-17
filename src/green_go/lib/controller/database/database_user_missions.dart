import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUserMissions {
  static final CollectionReference userMissionsCollection = FirebaseFirestore.instance.collection("user_missions");

  Future getUserMissions(String uid) async {
    return await userMissionsCollection.doc(uid).get();
  }

  Future deleteUserMission(String userId, Map<String,int> missionPoints) async {
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    List<dynamic> missions = doc['missions'];
    missions.remove(missionPoints);
    return await userMissionsCollection.doc(userId).update({'missions': missions});
  }

  Future addUserMission(String userId, Map<String,int> missionPoints) async {
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    List<dynamic> missions = doc['missions'];
    missions.add(missionPoints);
    return await userMissionsCollection.doc(userId).update({'missions': missions});
  }

  Future addCompletedMission(String userId, String missionId) async {
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    Map<String, dynamic> completedMissions = doc['completedMissions'];
    completedMissions[missionId] = Timestamp.now();
    return await userMissionsCollection.doc(userId).update({'completedMissions': completedMissions});
  }
}
