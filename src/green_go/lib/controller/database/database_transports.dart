import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseTransports{
  static final CollectionReference transportsCollection = FirebaseFirestore.instance.collection("transports");

  Future getAllData() async {
    //gets all the transports in the database
    return await transportsCollection.get();
  }
}
