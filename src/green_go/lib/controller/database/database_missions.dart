import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/model/missions_model.dart';

class DataBaseMissions{
  static final CollectionReference missionsCollection = FirebaseFirestore.instance.collection("missions");

  Future getAllData() async{
    return await missionsCollection.get();
  }

}