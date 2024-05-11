import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pair/pair.dart';

class DataBaseUserMissions {
  static final CollectionReference userMissionsCollection = FirebaseFirestore.instance.collection("user_missions");

  Future getUserMissions(String uid) async {
    return await userMissionsCollection.doc(uid).get();
  }
  Future deleteUserMission(String userId, String missionId, int points) async {
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    List<Pair<String,int>> missions = doc['missions'];
    missions.remove(Pair(missionId, points));
    return await userMissionsCollection.doc(userId).update({'missions': missions});
  }
  Future addUserMission(String userId, String missionID, int points) async {
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    List<Pair<String,int>> missions = doc['missions'];
    missions.add(Pair(missionID, points));
    return await userMissionsCollection.doc(userId).update({'missions': missions});
  }
  Future addCompletedMission(String userId, String missionId) async {
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    Map<String, Timestamp> completedMissions = doc['completedMissions'];
    completedMissions[missionId] = Timestamp.now();
    return await userMissionsCollection.doc(userId).update({'completedMissions': completedMissions});
  }
}
