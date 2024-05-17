import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/controller/verifiers/mission_verifier.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pair/pair.dart';
import 'mission_verifier_test.mocks.dart';



@GenerateNiceMocks([MockSpec<MissionsFetcher>(), MockSpec<DataBaseUserMissions>(), MockSpec<DataBaseUsers>(), MockSpec<AuthService>()])


class MockUser extends Mock implements User {
  @override
  String get uid => '123';
}
void main(){
  late AuthService authService;
  late DataBaseUsers dataBaseUsers;
  late DataBaseUserMissions dataBaseUserMissions;
  late MissionsFetcher missionsFetcher;
  late MissionVerifier missionVerifier;
  
  setUp(() {
    missionVerifier = MissionVerifier();
    authService = MockAuthService();
    dataBaseUserMissions = MockDataBaseUserMissions();
    dataBaseUsers = MockDataBaseUsers();
    missionsFetcher = MockMissionsFetcher();
    missionVerifier.setAuth(authService);
    missionVerifier.setDataBaseUserMissions(dataBaseUserMissions);
    missionVerifier.setDataBaseUsers(dataBaseUsers);
    missionVerifier.setMissionsFetcher(missionsFetcher);
    when(authService.getCurrentUser()).thenReturn(MockUser());
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

  group("updateMissionsWithDistance Tests", () {
    test("mission completed", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Distance" : 10}];
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      await missionVerifier.updateMissionsWithDistance(10.0, 15.0, mission);

      verify(dataBaseUserMissions.addCompletedMission("123", "a")).called(1);
      verify(dataBaseUsers.updateUserPoints("123", 100)).called(1);
    });

    test("partily completed mission", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Distance" : 10}];
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      await missionVerifier.updateMissionsWithDistance(10.0, 9.0, mission);

      verify(dataBaseUserMissions.addUserMission("123",{"a":9}));
    });
   });
  
  


}