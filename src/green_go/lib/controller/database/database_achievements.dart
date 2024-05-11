import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseAchievements {
  static final CollectionReference achievementsCollection = FirebaseFirestore.instance.collection("achievements");

  Future getAllAchievements() async {
    return await achievementsCollection.get();
  }
}

