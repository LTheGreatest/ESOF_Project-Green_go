import 'package:flutter/foundation.dart';
import 'package:green_go/controller/database/database_transports.dart';
import 'package:green_go/model/transport_model.dart';

class TransportsFetcher {
  DataBaseTransports db = DataBaseTransports();
  List<TransportModel> transports = [];

  Future<List<TransportModel>> getTransports() async {
    await db.getAllData().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        try {
          String transportName = docSnapshot.data()["name"];
          double pointsPerDist = docSnapshot.data()["pointsPerDist"];
          TransportModel transport = TransportModel(transportName, pointsPerDist);
          transports.add(transport);
        }
        catch(e) {
           if (kDebugMode) {
             print("Failed with error '${e.toString()}'");
           }
        }
      }
     });
     return transports;
  }
}
