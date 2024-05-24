import 'package:cloud_firestore/cloud_firestore.dart';



class DataBaseUserMissions {
  static final CollectionReference userMissionsCollection = FirebaseFirestore.instance.collection("user_missions");

  Future getUserMissions(String uid) async {
    //gets all the users missions
    return await userMissionsCollection.doc(uid).get();
  }

  Future deleteUserMission(String userId, Map<String,int> missionPoints) async {
    //delets a mission from the user missions section (because the mission will be transferred to the completed missions section)
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    List<dynamic> missions = doc['missions'];

    for (var element in missions) {
      if(element.entries.first.key == missionPoints.entries.first.key){
        missions.remove(element);
        break;
      }
    }
    await userMissionsCollection.doc(userId).update({'missions':FieldValue.delete()});


    return await userMissionsCollection.doc(userId).update({'missions': missions});
  }

  Future addUserMission(String userId, Map<String,int> missionPoints) async {
    //adds a mission to the user missions section
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    List<dynamic> missions = doc['missions'];
    missions.add(missionPoints);
    return await userMissionsCollection.doc(userId).update({'missions': missions});
  }

  Future addCompletedMission(String userId, String missionId) async {
    //adds a missions to the completed missions section
    DocumentSnapshot doc = await userMissionsCollection.doc(userId).get();
    Map<String, dynamic> completedMissions = doc['completedMissions'];
    completedMissions[missionId] = Timestamp.now();
    return await userMissionsCollection.doc(userId).update({'completedMissions': completedMissions});
  }
}
