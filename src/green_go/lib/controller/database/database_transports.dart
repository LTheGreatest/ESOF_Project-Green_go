import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseTransports{
  static final CollectionReference transportsCollection = FirebaseFirestore.instance.collection("transports");

  Future getAllData() async {
    return await transportsCollection.get();
  }

}