import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseTransports{
  static final CollectionReference trasportsCollection = FirebaseFirestore.instance.collection("transports");

  Future getAllData() async {
    return await trasportsCollection.get();
  }

}