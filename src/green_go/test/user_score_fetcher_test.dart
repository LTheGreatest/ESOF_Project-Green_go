import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'user_score_fetcher_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DataBaseUsers>()])

void main(){

  group("get users for leaderboard", (){
    test("get Data For Leaderboard", () async{
    UserFetcher fetcher = UserFetcher();
    DataBaseUsers db = MockDataBaseUsers();
    final instance =  FakeFirebaseFirestore();
    await instance.collection('users').add({
      'username' : "Lucas",
      "totalPoints": 100,
      "weeklyPoints" : 10,
      "monthlyPoints": 16
    });
    await instance.collection('users').add({
      'username' : "Rafael",
      "totalPoints": 101,
      "weeklyPoints" : 20,
      "monthlyPoints": 36
    });

    when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('users').get());
    fetcher.setDB(db);

    final users = await fetcher.getDataForLeaderboard();

    expectLater(users[0].username, "Lucas");
    expectLater(users[0].totalPoints, 100);
    expectLater(users[0].weeklyPoints, 10 );
    expectLater(users[0].monthlyPoints, 16);
    expectLater(users[1].username, "Rafael");
    expectLater(users[1].totalPoints, 101);
    expectLater(users[1].weeklyPoints, 20 );
    expectLater(users[1].monthlyPoints, 36);

  });

    test("get Data For Leaderboard but user parameters are missing", () async{
    UserFetcher fetcher = UserFetcher();
    DataBaseUsers db = MockDataBaseUsers();
    final instance =  FakeFirebaseFirestore();
    await instance.collection('users').add({
      'username' : "Lucas",
      "totalPoints": 100,

      "monthlyPoints": 16
    });
    await instance.collection('users').add({
      "totalPoints": 101,
      "weeklyPoints" : 20,
      "monthlyPoints": 36
    });

    when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('users').get());
    fetcher.setDB(db);

    final users = await fetcher.getDataForLeaderboard();

    expectLater(users.length, 0);
  });

    test("get Data For Leaderboard but there are no users", () async{
    UserFetcher fetcher = UserFetcher();
    DataBaseUsers db = MockDataBaseUsers();
    final instance =  FakeFirebaseFirestore();

    when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('users').get());
    fetcher.setDB(db);

    final users = await fetcher.getDataForLeaderboard();

    expectLater(users.length, 0);
  });
  });
  

}