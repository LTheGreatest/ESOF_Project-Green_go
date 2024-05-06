import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/widgets/score_main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'score_main_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CloudStorage>(), MockSpec<UserFetcher>()])

void main(){

  group("get current user", () { 
    test("get Current user", ( ) async {
      UserFetcher fetcherMock = MockUserFetcher();
      ScoreMainState state = ScoreMainState();
      UserModel user = UserModel("123", "Lucas");
      user.goal = 100;
      user.totalPoints = 2000;
      user.streak = 10;
      when(fetcherMock.getCurrentUserData()).thenAnswer((realInvocation) => Future.value(user));
      state.setFetcher(fetcherMock);

      await state.getCurrentUserData();

      expectLater(state.goal, 100);
      expectLater(state.score, 2000);
      expectLater(state.streak, 10);
      expectLater(state.completionPercentage, user.totalPoints/user.goal);

    });

    test("get Current user but score is 0", ( ) async {
      UserFetcher fetcherMock = MockUserFetcher();
      ScoreMainState state = ScoreMainState();
      UserModel user = UserModel("123", "Lucas");
      user.goal = 100;
      user.totalPoints = 0;
      user.streak = 10;
      when(fetcherMock.getCurrentUserData()).thenAnswer((realInvocation) => Future.value(user));
      state.setFetcher(fetcherMock);

      await state.getCurrentUserData();

      expectLater(state.goal, 100);
      expectLater(state.score, 0);
      expectLater(state.streak, 10);
      expectLater(state.completionPercentage, 0);

    });
  });

  group("Fetch icons", () { 
    test("Fetch icons", () async{
      CloudStorage storage = MockCloudStorage();
      when(storage.downloadFileURL("icons/Score.png")).thenAnswer((realInvocation) => Future.value("teste1"));
      when(storage.downloadFileURL('icons/Goal.png')).thenAnswer((realInvocation) => Future.value("teste2"));
      when(storage.downloadFileURL('icons/Streak.png')).thenAnswer((realInvocation) => Future.value("teste3"));
      ScoreMainState state = ScoreMainState();
      state.setStorage(storage);

      await state.fetchIcons();
      
      expectLater(state.scoreIcon,"teste1" );
      expectLater(state.goalIcon, "teste2");
      expectLater(state.streakIcon, "teste3");
      
    });
  });
}