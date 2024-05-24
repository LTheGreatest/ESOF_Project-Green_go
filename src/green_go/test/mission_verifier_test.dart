import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/controller/verifiers/achievement_verifier.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/controller/verifiers/mission_verifier.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pair/pair.dart';
import 'mission_verifier_test.mocks.dart';



@GenerateNiceMocks([MockSpec<MissionsFetcher>(), MockSpec<DataBaseUserMissions>(), MockSpec<DataBaseUsers>(), MockSpec<AuthService>(),MockSpec<AchievementVerifier>()])


Future<List<dynamic>> getMissionsInProgressMock() async{
  return [{"c":5},{"d" : 100}];
}

Future<Map<String,dynamic>> getcompletedMissionsMock() async{
  return {"b" : DateTime.now()};
}

class MockUser extends Mock implements User {
  @override
  String get uid => '123';
}

class MockBuildContext extends Mock implements BuildContext{
  @override
  bool get mounted => true;
}

void main(){
  late AuthService authService;
  late DataBaseUsers dataBaseUsers;
  late DataBaseUserMissions dataBaseUserMissions;
  late MissionsFetcher missionsFetcher;
  late AchievementVerifier achievementVerifier;
  late MissionVerifier missionVerifier;
  late MockBuildContext context;

  setUp(() {
    missionVerifier = MissionVerifier();
    authService = MockAuthService();
    dataBaseUserMissions = MockDataBaseUserMissions();
    dataBaseUsers = MockDataBaseUsers();
    missionsFetcher = MockMissionsFetcher();
    context = MockBuildContext();
    achievementVerifier = MockAchievementVerifier();
    missionVerifier.setAuth(authService);
    missionVerifier.setDataBaseUserMissions(dataBaseUserMissions);
    missionVerifier.setDataBaseUsers(dataBaseUsers);
    missionVerifier.setMissionsFetcher(missionsFetcher);
    missionVerifier.setAchievementVerifier(achievementVerifier);
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
      await missionVerifier.updateMissionsWithDistance(context,10.0, 15.0, mission);

      verify(dataBaseUserMissions.addCompletedMission("123", "a")).called(1);
      verify(dataBaseUsers.updateUserPoints("123", 100)).called(1);
      verifyNever(dataBaseUserMissions.addUserMission("123",{"a":15}));
    });

    test("partily completed mission", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Distance" : 10}];
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      await missionVerifier.updateMissionsWithDistance(context,10.0, 9.0, mission);

      verify(dataBaseUserMissions.addUserMission("123",{"a":9}));
      verifyNever(dataBaseUserMissions.addCompletedMission("123", "a"));
      verifyNever(dataBaseUsers.updateUserPoints("123", 100));
    });
  });


  group("updatePointsWithPoints Tests", () {
    test("mission completed", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Points" : 5}];
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      await missionVerifier.updateMissionsWithPoints(context,5, 10, mission);

      verify(dataBaseUserMissions.addCompletedMission("123", "a")).called(1);
      verify(dataBaseUsers.updateUserPoints("123", 100)).called(1);
      verifyNever(dataBaseUserMissions.addUserMission("123",{"a":10}));
    });

    test("partily completed mission", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Points" : 10}];
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      await missionVerifier.updateMissionsWithPoints(context,10, 5, mission);

      verify(dataBaseUserMissions.addUserMission("123",{"a":5}));
      verifyNever(dataBaseUserMissions.addCompletedMission("123", "a"));
      verifyNever(dataBaseUsers.updateUserPoints("123", 100));
    });
  });

  group("updateCompletedMissions Tests", () {
    test("partily completed missions", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Points" : 20}];
      List<dynamic> types2 = ["Bus","Train",{"Distance" : 100}];
      List<dynamic> types3 = ["Bus","Metro",{"Points" : 15}];
      List<dynamic> types4 = ["Metro",{"Distance" : 1000}];

      TransportModel transport = TransportModel("Bus", 1.2);
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      MissionsModel m2 = MissionsModel("title", "description", "frequency", types2, 150);
      MissionsModel m3 = MissionsModel("title", "description", "frequency", types3, 10);
      MissionsModel m4 = MissionsModel("title", "description", "frequency", types4, 12);

      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      Pair<String,MissionsModel> mission2 = Pair<String,MissionsModel>("b",m2);
      Pair<String,MissionsModel> mission3 = Pair<String,MissionsModel>("c",m3);
      Pair<String,MissionsModel> mission4 = Pair<String,MissionsModel>("d",m4);


      List<Pair<String,MissionsModel>> missions = [mission,mission2,mission3,mission4];


      when(missionsFetcher.missionsId).thenReturn(missions);
      when(missionsFetcher.getCompletedMissionsId("123")).thenAnswer( (realInvocation) => Future.value(getcompletedMissionsMock()));
      when(missionsFetcher.getMissionsInProgress("123")).thenAnswer(  (realInvocation) => Future.value(getMissionsInProgressMock()));

      await missionVerifier.updateCompletedMissions(context,9, transport,10 );

      //test if a mission that is partily completed is completed when the conditions are met
      verify(dataBaseUserMissions.deleteUserMission("123", {"c" : 5})).called(1);
      verify(dataBaseUserMissions.addCompletedMission("123", "c")).called(1);
      verifyNever(dataBaseUserMissions.addUserMission("123", {"c" : 15}));
      verify(dataBaseUsers.updateUserPoints("123", 10)).called(1);

      //tests if a mission has added when partily completed
      verify(dataBaseUserMissions.addUserMission("123", {"a" : 10})).called(1);

      //tests that non compatible mission is not used
      verifyNever(dataBaseUserMissions.deleteUserMission("123", {"d" : 100}));

      //tests if a mission that has already completed is not added again
      verifyNever(dataBaseUserMissions.deleteUserMission("123", {"b" : 9}));
      verifyNever(dataBaseUserMissions.addUserMission("123", {"b" : 9}));

    });

    test("completed without prior progress", () async{
      List<dynamic> types = ["Bus","Metro","Train",{"Points" : 20}];
      List<dynamic> types2 = ["Bus","Train",{"Distance" : 100}];
      List<dynamic> types3 = ["Bus","Metro"];
      List<dynamic> types4 = ["Metro",{"Distance" : 1000}];
      List<dynamic> types5 = ["Bus",{"Points" : 10}];

      TransportModel transport = TransportModel("Bus", 1.2);
      MissionsModel m = MissionsModel("title", "description", "frequency", types, 100);
      MissionsModel m2 = MissionsModel("title", "description", "frequency", types2, 150);
      MissionsModel m3 = MissionsModel("title", "description", "frequency", types3, 10);
      MissionsModel m4 = MissionsModel("title", "description", "frequency", types4, 12);
      MissionsModel m5 = MissionsModel("title", "description", "frequency", types5, 12);

      Pair<String,MissionsModel> mission = Pair<String,MissionsModel>("a",m);
      Pair<String,MissionsModel> mission2 = Pair<String,MissionsModel>("b",m2);
      Pair<String,MissionsModel> mission3 = Pair<String,MissionsModel>("c",m3);
      Pair<String,MissionsModel> mission4 = Pair<String,MissionsModel>("d",m4);
      Pair<String,MissionsModel> mission5 = Pair<String,MissionsModel>("e",m5);

      List<Pair<String,MissionsModel>> missions = [mission,mission2,mission3,mission4,mission5];

      when(missionsFetcher.missionsId).thenReturn(missions);
      when(missionsFetcher.getCompletedMissionsId("123")).thenAnswer( (realInvocation) => Future.value(getcompletedMissionsMock()));
      when(missionsFetcher.getMissionsInProgress("123")).thenAnswer(  (realInvocation) => Future.value([]));

      await missionVerifier.updateCompletedMissions(context,100, transport,10 );

      verify(dataBaseUserMissions.addCompletedMission("123", "c"));
      verify(dataBaseUserMissions.addCompletedMission("123", "e"));

      verify(dataBaseUserMissions.addUserMission("123", {"a" : 10}));

      verifyNever(dataBaseUserMissions.addUserMission("123", {"d" : 100}));

      verifyNever(dataBaseUserMissions.addCompletedMission("123", "b"));

    });
  });
  
  


}