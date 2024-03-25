import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUsers {
  static final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future addUser(String uid, String username) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'points': 0
    });
  }
  Future updateUsername(String uid, String username) async {
     return await userCollection.doc(uid).set({
      'username': username
     });
  }
  Future updateUserPoints(String uid, int points) async {
    int pointsInDB = 0;

    DocumentSnapshot doc = await userCollection.doc(uid).get();
    pointsInDB = doc['points'];
    
    userCollection.doc(uid).update({'points': pointsInDB + points});

  }
  Future getAllData() async {
    return await userCollection.get();
  }
}
