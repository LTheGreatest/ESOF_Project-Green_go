import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/controller/verifiers/mission_verifier.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pair/pair.dart';





void main(){
  late MissionVerifier missionVerifier;
  setUp(() {
    missionVerifier = MissionVerifier();
  });
  group("compatibleTransports Tests", () {
    test("is compatible", () {
      List<dynamic> types = ["Bus","Metro",{"points" : 0}];
      TransportModel transport = TransportModel("Bus", 1.2);
      bool res = missionVerifier.compatibleTransport(types, transport);

      expect(res, equals(true));
    });

    test("is not compatible", () {
      List<dynamic> types = ["Bus","Metro",{"points" : 0}];
      TransportModel transport = TransportModel("Train", 1.2);
      bool res = missionVerifier.compatibleTransport(types, transport);

      expect(res, equals(false));
    });
  });

   group("getMissionType Tests", () { 
    test("type found", () {
      List<dynamic> types = ["Bus","Metro",{"points" : 0}];
      Pair<String , double> res = missionVerifier.getMissionType(types);
      Pair<String,double> rightRes = const Pair<String,double>("points",0);
      expect(res, equals(rightRes));
    });

    test("type not found", () {
      List<dynamic> types = ["Bus","Metro","Train"];
      Pair<String , double> res = missionVerifier.getMissionType(types);
      Pair<String,double> rightRes = const Pair<String,double>("",0);
      expect(res, equals(rightRes));
    });
  });


  
  


}