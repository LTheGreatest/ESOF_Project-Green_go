import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserFetcher>(), MockSpec<CloudStorage>()])

void main(){
  group("calculate age", () {
      test("calculate age", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(2020, 10, 1));
        expect(age >= 3, true);
      });

      test("calculate age but is in the future", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(10000, 10, 1));
        expect(age, 18);
      });

      test("calculate age but the month is more than the now time", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(DateTime.now().year - 2,DateTime.now().month + 1, 1));
        expect(age, DateTime.now().year + 1 - DateTime.now().year);
      });

      test("calculate age but the day is more than the now time", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(DateTime.now().year - 2,DateTime.now().month, DateTime.now().day + 1));
        expect(age, DateTime.now().year + 1 - DateTime.now().year);
      });
   });

  group("test initialization", (){
    test("test initialization",() async{
      //given
      CloudStorage storage = MockCloudStorage();
      ProfilePageState page = ProfilePageState();
      UserFetcher fetcher = MockUserFetcher();
      UserModel user = UserModel("123", "Lucas");
      user.birthDate = DateTime(2020, 2, 10);
      user.job = "Engineer";
      user.nationality = "Portugues";
      user.photoUrl = "ioewur+";
      Future<UserModel> futureUser = Future.value(user);
      when(fetcher.getCurrentUserData()).thenAnswer((realInvocation) => futureUser);
      when(storage.downloadFileURL("icons/Default_pfp.png")).thenAnswer((realInvocation) => Future.value("default"));
      page.setUserFetcher(fetcher);
      page.setCloudStorage(storage);

      //when
      await page.initializeUserVariables();

      //then
      expectLater(page.name, "Lucas");
      expectLater(page.nationality, "Portugues");
      expectLater(page.age, page.calculateAge(user.birthDate));
      expectLater(page.job, "Engineer");
      expectLater(page.uid, "123");
      expectLater(page.photoUrl,"ioewur+" );

    });

    test("test initialization but the user doesn't have a profile photo",() async{
      //given
      CloudStorage storage = MockCloudStorage();
      ProfilePageState page = ProfilePageState();
      UserFetcher fetcher = MockUserFetcher();
      UserModel user = UserModel("123", "Lucas");
      user.birthDate = DateTime(2020, 2, 10);
      user.job = "Engineer";
      user.nationality = "Portugues";
      user.photoUrl = "";
      Future<UserModel> futureUser = Future.value(user);
      when(fetcher.getCurrentUserData()).thenAnswer((realInvocation) => futureUser);
      when(storage.downloadFileURL("icons/Default_pfp.png")).thenAnswer((realInvocation) => Future.value("default"));
      page.setUserFetcher(fetcher);
      page.setCloudStorage(storage);

      //when
      await page.initializeUserVariables();

      //then
      expectLater(page.name, "Lucas");
      expectLater(page.nationality, "Portugues");
      expectLater(page.age, page.calculateAge(user.birthDate));
      expectLater(page.job, "Engineer");
      expectLater(page.uid, "123");
      expectLater(page.photoUrl,"default" );

    });
  });
}