import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/model/transport_model.dart';

class TransportsIconsFetcher {
  List<List<dynamic>> transportIcons = [];
  late CloudStorage storage = CloudStorage();

  void setStorage(CloudStorage cloudStorage) {
    storage = cloudStorage;
  }
  Future<List<List<dynamic>>> getTransportsIcons(List<TransportModel> transports) async {
    // gets the transport icons from the firebase storage database
    for (int i = 0; i < transports.length; i++) {
      String path = "icons/${transports[i].getName()}.png";
      Future<String> futureURL = storage.downloadFileURL(path);
      String url = "";
      try {
        await futureURL.then((value) => url = value);
        Image img = Image.network(url, fit: BoxFit.scaleDown);
        transportIcons.add([img, transports[i].getName()]);
      } catch(e) {
        if (kDebugMode) {
          print("Failed with error '${e.toString()}'");
        }
      }
    }
    return transportIcons;
  }
}
