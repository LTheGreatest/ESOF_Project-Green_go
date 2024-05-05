import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/pages/profile_edit_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'profile_test.mocks.dart';
import 'user_score_fetcher_test.mocks.dart';

class MockUser extends Mock implements User {
  @override
  String get uid => '1234';
}
class UsernameControllerMock extends Mock implements TextEditingController{
  @override
  String get text => "Lucas";
}

class NationalityControllerMock extends Mock implements TextEditingController{
  @override
  String get text => "Portuguese";
}

class JobControllerMock extends Mock implements TextEditingController{
  @override
  String get text => "Engineer";
}

void main(){

  test("store data behaviour", (){
    DataBaseUsers db = MockDataBaseUsers();
    AuthService auth = MockAuthService();
    User user = MockUser();
    TextEditingController usernameController = UsernameControllerMock();
    TextEditingController nationalityController = NationalityControllerMock();
    TextEditingController jobController = JobControllerMock();
    when(auth.getCurrentUser()).thenAnswer((realInvocation) => user);
    
    EditPageViewer editpage = EditPageViewer();
    editpage.setUsersDB(db);
    editpage.setControllers(usernameController, nationalityController, jobController);
    editpage.setAuth(auth);


    editpage.saveChangesAndUpdateProfile();

    verify(db.updateUserProfile("1234", "Lucas", "Portuguese", "Engineer", DateTime(DateTime.now().year - 18))).called(1);
  });

  group("initialize the variables", (){
    test("initialize variables 1", () async{
      EditPageViewer editpage = EditPageViewer();
      CloudStorage storage = MockCloudStorage();
      UserFetcher fetcher = MockUserFetcher();
      UserModel user = UserModel("123", "Lucas");
      user.birthDate = DateTime(0, 0, 0);
      user.job = "Gas expert";
      user.nationality = "?12*+´çã";
      user.photoUrl = "aswa";
      Future<UserModel> futureUser = Future.value(user);
      when(fetcher.getCurrentUserData()).thenAnswer((realInvocation) => futureUser);
      when(storage.downloadFileURL("icons/Default_pfp.png")).thenAnswer((realInvocation) => Future.value("default"));
      editpage.setUserFetcher(fetcher);
      editpage.setCloudStorage(storage);

      await editpage.initializeUserVariables();

      expectLater(editpage.usernameController.text, "Lucas");
      expectLater(editpage.nationalityController.text, "?12*+´çã");
      expectLater(editpage.jobController.text, "Gas expert");
      expectLater(editpage.birthDate, DateTime(0,0,0));
      expectLater(editpage.photoUrl, "aswa");
    });

    test("initialize variables 2", () async{
      EditPageViewer editpage = EditPageViewer();
      CloudStorage storage = MockCloudStorage();
      UserFetcher fetcher = MockUserFetcher();
      UserModel user = UserModel("123", "Lucas");
      user.birthDate = DateTime(2020, 2, 10);
      user.job = "Engineer";
      user.nationality = "Portugues";
      user.photoUrl = "ioewur+";
      Future<UserModel> futureUser = Future.value(user);
      when(fetcher.getCurrentUserData()).thenAnswer((realInvocation) => futureUser);
      when(storage.downloadFileURL("icons/Default_pfp.png")).thenAnswer((realInvocation) => Future.value("default"));
      editpage.setUserFetcher(fetcher);
      editpage.setCloudStorage(storage);

      await editpage.initializeUserVariables();

      expectLater(editpage.usernameController.text, "Lucas");
      expectLater(editpage.nationalityController.text, "Portugues");
      expectLater(editpage.jobController.text, "Engineer");
      expectLater(editpage.birthDate, DateTime(2020, 2, 10));
      expectLater(editpage.photoUrl, "ioewur+");
    });

    test("initialize variables but the user doesn't have a profile picture 1", () async{
      EditPageViewer editpage = EditPageViewer();
      CloudStorage storage = MockCloudStorage();
      UserFetcher fetcher = MockUserFetcher();
      UserModel user = UserModel("123", "Lucas");
      user.birthDate = DateTime(2020, 2, 10);
      user.job = "Engineer";
      user.nationality = "Portugues";
      user.photoUrl = "";
      Future<UserModel> futureUser = Future.value(user);
      when(fetcher.getCurrentUserData()).thenAnswer((realInvocation) => futureUser);
      when(storage.downloadFileURL("icons/Default_pfp.png")).thenAnswer((realInvocation) => Future.value("default"));
      editpage.setUserFetcher(fetcher);
      editpage.setCloudStorage(storage);

      await editpage.initializeUserVariables();

      expectLater(editpage.usernameController.text, "Lucas");
      expectLater(editpage.nationalityController.text, "Portugues");
      expectLater(editpage.jobController.text, "Engineer");
      expectLater(editpage.birthDate, DateTime(2020, 2, 10));
      expectLater(editpage.photoUrl, "default");
    });

    test("initialize variables but the user doesn't have a profile picture 2", () async{
      EditPageViewer editpage = EditPageViewer();
      CloudStorage storage = MockCloudStorage();
      UserFetcher fetcher = MockUserFetcher();
      UserModel user = UserModel("123", "Lucas");
      user.birthDate = DateTime(2020, 2, 10);
      user.job = "Gas expert";
      user.nationality = "?12*+´çã";
      user.photoUrl = "";
      Future<UserModel> futureUser = Future.value(user);
      when(fetcher.getCurrentUserData()).thenAnswer((realInvocation) => futureUser);
      when(storage.downloadFileURL("icons/Default_pfp.png")).thenAnswer((realInvocation) => Future.value("default"));
      editpage.setUserFetcher(fetcher);
      editpage.setCloudStorage(storage);

      await editpage.initializeUserVariables();

      expectLater(editpage.usernameController.text, "Lucas");
      expectLater(editpage.nationalityController.text, "?12*+´çã");
      expectLater(editpage.jobController.text, "Gas expert");
      expectLater(editpage.birthDate, DateTime(2020, 2, 10));
      expectLater(editpage.photoUrl, "default");
    });
  });

}