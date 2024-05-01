import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'user_score_fetcher_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DataBaseUsers>(), MockSpec<AuthService>()])
class MockUser extends Mock implements User {
  @override
  String get uid => '1234';
}
void main(){

  group("get users for leaderboard", (){

    
    test("get Data For Leaderboard", () async{
      //given
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

      //when
      final users = await fetcher.getDataForLeaderboard();

      //then
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
      //given
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

      //when
      final users = await fetcher.getDataForLeaderboard();

      //then
      expectLater(users.length, 0);
    });

    test("get Data For Leaderboard but there are no users", () async{
      //given
      UserFetcher fetcher = UserFetcher();
      DataBaseUsers db = MockDataBaseUsers();
      final instance =  FakeFirebaseFirestore();

      when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('users').get());
      fetcher.setDB(db);

      //when
      final users = await fetcher.getDataForLeaderboard();

      //then
      expectLater(users.length, 0);
    });
  });

  group("get user data", (){

      UserFetcher fetcher = UserFetcher();
      DataBaseUsers db = MockDataBaseUsers();
      final instance =  FakeFirebaseFirestore();
      AuthService auth = MockAuthService();
      User user = MockUser();
    test("get user data", () async{
      //given
      await instance.collection("users").doc("1234").set(
        {
      'username' : "Lucas",
      "totalPoints": 100,
      "firstTime" : true,
      "monthlyPoints": 16,
      "weeklyPoints": 10,
      "goal" : 0,
      "job" :  "Student",
      "birthDate" : Timestamp.fromDate(DateTime(2006)),
      "nationality": "Portuguese",
      "photoUrl" : "https://firebasestorage.googleapis.com/v0/b/green-go-ba24b.appspot.com/o/profile_pictures%2F2024-04-24%2018%3A01%3A46.746120.jpg?alt=media&token=ac4a37cf-d0ab-4884-be38-70e0d4155391",
      "streak" : 0
    }
      );


      when(auth.getCurrentUser()).thenAnswer((realInvocation) => user);
      when(db.getUserData("1234")).thenAnswer((realInvocation) => instance.collection("users").doc("1234").get());
      fetcher.setDB(db);
      fetcher.setAuth(auth);

      //when
      UserModel model = await fetcher.getCurrentUserData();

      //then
      expectLater(model.username, "Lucas");
      expectLater(model.totalPoints, 100);
      expectLater(model.firstTime, true);
      expectLater(model.monthlyPoints, 16);
      expectLater(model.goal, 0);
      expectLater(model.job, "Student");
      expectLater(model.nationality, "Portuguese");
      expectLater(model.streak, 0);


    });

    test("get user data but some parameter is missig", () async{
      //given
      await instance.collection("users").doc("1234").set(
        {
      "totalPoints": 100,
      "firstTime" : true,
      "monthlyPoints": 16,
      "weeklyPoints": 10,
      "goal" : 0,
      "job" :  "Student",
      "birthDate" : Timestamp.fromDate(DateTime(2006)),
      "nationality": "Portuguese",
      "photoUrl" : "https://firebasestorage.googleapis.com/v0/b/green-go-ba24b.appspot.com/o/profile_pictures%2F2024-04-24%2018%3A01%3A46.746120.jpg?alt=media&token=ac4a37cf-d0ab-4884-be38-70e0d4155391",
      "streak" : 0
    }
      );


      when(auth.getCurrentUser()).thenAnswer((realInvocation) => user);
      when(db.getUserData("1234")).thenAnswer((realInvocation) => instance.collection("users").doc("1234").get());
      fetcher.setDB(db);
      fetcher.setAuth(auth);

      //when
      UserModel model = await fetcher.getCurrentUserData();

      //then
      expectLater(model.username, "notDefined");


    });

    test("get user data but user doesn't exists", () async{
      //given
      when(auth.getCurrentUser()).thenAnswer((realInvocation) => user);
      when(db.getUserData("1234")).thenAnswer((realInvocation) => instance.collection("users").doc("1234").get());
      fetcher.setDB(db);
      fetcher.setAuth(auth);

      //when
      UserModel model = await fetcher.getCurrentUserData();

      //then
      expectLater(model.username, "notDefined");


    });

  });
  

}