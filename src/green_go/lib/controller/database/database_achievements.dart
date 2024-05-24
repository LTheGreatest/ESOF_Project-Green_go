import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseAchievements {
  static final CollectionReference achievementsCollection = FirebaseFirestore.instance.collection("achievements");

  Future getAllAchievements() async {
    //gets all the achievements in the database
    return await achievementsCollection.get();
  }
}

