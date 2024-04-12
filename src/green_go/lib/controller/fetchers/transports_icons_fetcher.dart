import 'package:flutter/material.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/model/transport_model.dart';

class TransportsIconsFetcher{
  List<List<dynamic>> transportIcons =  [];
  CloudStorage storage = CloudStorage();

  Future<List<List<dynamic>>> getTransportsIcons(List<TransportModel> transports) async{

    for(int i = 0; i < transports.length; i++){

      String path = "icons/${transports[i].getName()}.png";
      Future<String> futureURL = storage.dowloadFileURL(path);
      String url = "";

      try{
        await futureURL.then((value) => url = value);
        Image img = Image.network(url, fit: BoxFit.scaleDown);
        transportIcons.add([img, transports[i].getName()]);
      } catch(e) {
        print("Failed with error '${e.toString()}'");
      }
      
    }
    return transportIcons;
  }
}