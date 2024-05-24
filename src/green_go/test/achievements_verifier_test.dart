

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_user_achievements.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/achievements_fetcher.dart';
import 'package:green_go/controller/verifiers/achievement_verifier.dart';
import 'package:green_go/model/achievements_model.dart';
import 'package:green_go/view/widgets/achievement_popup.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pair/pair.dart';


import 'achievements_verifier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AchievementsFetcher>(), MockSpec<DataBaseUserAchievements>(), MockSpec<DataBaseUsers>(), MockSpec<AuthService>(), MockSpec<AchievementPopup>()])
class MockBuildContext extends Mock implements BuildContext{
  @override
  bool get mounted => true;
}

void main(){
  late BuildContext context;
  late AchievementVerifier verifier;
  late AchievementsFetcher fetcher;
  late DataBaseUserAchievements uadb;
  late AchievementPopup popup;

  setUp((){
    context = MockBuildContext();
    verifier = AchievementVerifier();
    fetcher = MockAchievementsFetcher();
    uadb = MockDataBaseUserAchievements();
    popup = MockAchievementPopup();
    
  });

  group("update completed achivements", (){
    test("update completed achivements and currentNumber == numberRequired", () async{
      //given
      AchievementsModel model = AchievementsModel("teste", "teste", ["teste"]);
      AchievementPopup popup = MockAchievementPopup();
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      
      //when
      await verifier.updateCompletedAchievement(context, "123", 10, 10, "teste",model );

      //then
      verify(uadb.deleteUserAchievement("123", "teste")).called(1);
      verify(uadb.addCompletedAchievement("123", "teste")).called(1);
      verify(popup.show(context, model)).called(1);

    });

    test("update completed achivements and currentNumber > numberRequired", () async{
      //given
      AchievementsModel model = AchievementsModel("teste", "teste", ["teste"]);
      AchievementPopup popup = MockAchievementPopup();
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      
      //when
      await verifier.updateCompletedAchievement(context, "123", 10, 11, "teste",model );

      //then
      verify(uadb.deleteUserAchievement("123", "teste")).called(1);
      verify(uadb.addCompletedAchievement("123", "teste")).called(1);
      verify(popup.show(context, model)).called(1);
      
    });

    test("update completed achivements and currentNumber < numberRequired", () async{
      //given
      AchievementsModel model = AchievementsModel("teste", "teste", ["teste"]);
      
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      
      //when
      await verifier.updateCompletedAchievement(context, "123", 10, 9, "teste",model );

      //then
      verify(uadb.addUserAchievement("123", "teste", 9)).called(1);

      
    });
  });

  group("Update Completed Login Achievements", (){
    test("Update Completed Login Achivements", () async {
      //Given
      AchievementsModel model = AchievementsModel("Teste", "incrivel", ["NumberLogins", {"number": 20}]);
      List<Pair<String, AchievementsModel>> achivementsIDFake = [Pair("teste", model)];
      Map<String, int> map = {'teste' : 21};
      when(fetcher.getAchievementsID()).thenReturn(achivementsIDFake);
      when(fetcher.getUncompletedAchievementsId("123")).thenAnswer((realInvocation) => Future.value(map));
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      verifier.setAchievementsFetcher(fetcher);
      
      //when
      await verifier.updateCompletedLoginAchievements(context, "123");

      //then
      verify(fetcher.getAllAchievements()).called(1);
      verify(fetcher.getAchievementsID()).called(1);
      verify(uadb.addCompletedAchievement("123", "teste")).called(1);
      verify(uadb.deleteUserAchievement("123", "teste")).called(1);
      verify(popup.show(context, model)).called(1);


    });

    test("Update Completed Login Achivements but the missions aren't login ones", () async {
      //Given
      AchievementsModel model = AchievementsModel("Teste", "incrivel", ["NumberTrips", {"number": 20}]);
      List<Pair<String, AchievementsModel>> achivementsIDFake = [Pair("teste", model)];
      Map<String, int> map = {'teste' : 21};
      when(fetcher.getAchievementsID()).thenReturn(achivementsIDFake);
      when(fetcher.getUncompletedAchievementsId("123")).thenAnswer((realInvocation) => Future.value(map));
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      verifier.setAchievementsFetcher(fetcher);
      
      //when
      await verifier.updateCompletedLoginAchievements(context, "123");

      //then
      verify(fetcher.getAllAchievements()).called(1);
      verify(fetcher.getAchievementsID()).called(1);
      verifyNever(uadb.addCompletedAchievement("123", "teste"));
      verifyNever(uadb.deleteUserAchievement("123", "teste"));
      verifyNever(popup.show(context, model));


    });
  });

    group("Update Completed Trip Achievements", (){
    test("Update Completed Trip Achivements", () async {
      //Given
      AchievementsModel model = AchievementsModel("Teste", "incrivel", ["NumberTrips", {"number": 20}]);
      List<Pair<String, AchievementsModel>> achivementsIDFake = [Pair("teste", model)];
      Map<String, int> map = {'teste' : 21};
      when(fetcher.getAchievementsID()).thenReturn(achivementsIDFake);
      when(fetcher.getUncompletedAchievementsId("123")).thenAnswer((realInvocation) => Future.value(map));
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      verifier.setAchievementsFetcher(fetcher);
      
      //when
      await verifier.updateCompletedTripAchievements(context, "123");

      //then
      verify(fetcher.getAllAchievements()).called(1);
      verify(fetcher.getAchievementsID()).called(1);
      verify(uadb.addCompletedAchievement("123", "teste")).called(1);
      verify(uadb.deleteUserAchievement("123", "teste")).called(1);
      verify(popup.show(context, model)).called(1);


    });

    test("Update Completed trip Achivements but the missions aren't trip ones", () async {
      //Given
      AchievementsModel model = AchievementsModel("Teste", "incrivel", ["NumberLogins", {"number": 20}]);
      List<Pair<String, AchievementsModel>> achivementsIDFake = [Pair("teste", model)];
      Map<String, int> map = {'teste' : 21};
      when(fetcher.getAchievementsID()).thenReturn(achivementsIDFake);
      when(fetcher.getUncompletedAchievementsId("123")).thenAnswer((realInvocation) => Future.value(map));
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      verifier.setAchievementsFetcher(fetcher);
      
      //when
      await verifier.updateCompletedTripAchievements(context, "123");

      //then
      verify(fetcher.getAllAchievements()).called(1);
      verify(fetcher.getAchievementsID()).called(1);
      verifyNever(uadb.addCompletedAchievement("123", "teste"));
      verifyNever(uadb.deleteUserAchievement("123", "teste"));
      verifyNever(popup.show(context, model));


    });
  });

  group("Update Completed Missions Achievements", (){
    test("Update Completed Missions Achivements", () async {
      //Given
      AchievementsModel model = AchievementsModel("Teste", "incrivel", ["NumberMissions", {"number": 20}]);
      List<Pair<String, AchievementsModel>> achivementsIDFake = [Pair("teste", model)];
      Map<String, int> map = {'teste' : 21};
      when(fetcher.getAchievementsID()).thenReturn(achivementsIDFake);
      when(fetcher.getUncompletedAchievementsId("123")).thenAnswer((realInvocation) => Future.value(map));
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      verifier.setAchievementsFetcher(fetcher);
      
      //when
      await verifier.updateCompletedMissionAchievements(context, "123");

      //then
      verify(fetcher.getAllAchievements()).called(1);
      verify(fetcher.getAchievementsID()).called(1);
      verify(uadb.addCompletedAchievement("123", "teste")).called(1);
      verify(uadb.deleteUserAchievement("123", "teste")).called(1);
      verify(popup.show(context, model)).called(1);


    });

    test("Update Completed Missions Achivements but the missions aren't Missions ones", () async {
      //Given
      AchievementsModel model = AchievementsModel("Teste", "incrivel", ["NumberLogins", {"number": 20}]);
      List<Pair<String, AchievementsModel>> achivementsIDFake = [Pair("teste", model)];
      Map<String, int> map = {'teste' : 21};
      when(fetcher.getAchievementsID()).thenReturn(achivementsIDFake);
      when(fetcher.getUncompletedAchievementsId("123")).thenAnswer((realInvocation) => Future.value(map));
      verifier.setDataBaseUserAchievements(uadb);
      verifier.setPopUp(popup);
      verifier.setAchievementsFetcher(fetcher);
      
      //when
      await verifier.updateCompletedMissionAchievements(context, "123");

      //then
      verify(fetcher.getAllAchievements()).called(1);
      verify(fetcher.getAchievementsID()).called(1);
      verifyNever(uadb.addCompletedAchievement("123", "teste"));
      verifyNever(uadb.deleteUserAchievement("123", "teste"));
      verifyNever(popup.show(context, model));


    });
  });


}