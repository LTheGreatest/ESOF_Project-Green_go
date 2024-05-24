import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMissions {
  static final CollectionReference missionsCollection = FirebaseFirestore.instance.collection("missions");

  Future getAllMissions() async {
    //gets all the missions in the database
    return await missionsCollection.get();
  }
}
