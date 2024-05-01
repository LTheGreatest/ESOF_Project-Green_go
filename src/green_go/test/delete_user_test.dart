import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/model/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:green_go/controller/database/database_users.dart';

import 'user_login_test.mocks.dart';


class MockUserCredential extends Mock implements UserCredential {}
class MockDataBaseUsers extends Mock implements DataBaseUsers {
  @override
  Future addUser(UserModel user) {
    return Future.value();
  }
  
}
class MockUser extends Mock implements User {
  @override
  String get uid => '123';

  /*
  @override
  Future<void> delete()async {
    
  }
  */
}

@GenerateNiceMocks([MockSpec<FirebaseAuth>()])

void main(){
  late MockFirebaseAuth firebaseAuth;
  late AuthService authService;
  late MockDataBaseUsers mockDataBaseUsers;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    authService = AuthService();
    mockDataBaseUsers = MockDataBaseUsers();
    authService.setFirebaseAuth(firebaseAuth);
    authService.setDataBaseUsers(mockDataBaseUsers);
  });

  group('delete tests', ()  {
    test('delete faild source: database', () async {
      when(mockDataBaseUsers.deleteUser("failtest")).thenThrow("deletion from database faild");

      final result = await authService.deleteUser();

      expect(result, equals("Invalid deletion from database"));
    });

    /*

    test('delete - faild source: auth', () async {
      User mockUser = MockUser();
      when(firebaseAuth.currentUser).thenReturn(mockUser);
      when(mockDataBaseUsers.deleteUser('123')).thenAnswer((_) async {});
      when(mockUser.delete()).thenAnswer((_) async {});
      when(mockUser.delete()).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      final result= await authService.deleteUser();
      expect(result, equals('user-not-found'));
    });
    */

    test('deletion success',  () async{
      when(firebaseAuth.currentUser).thenReturn(MockUser());
      await authService.deleteUser();
      verify(mockDataBaseUsers.deleteUser('123'));
      verify(firebaseAuth.currentUser?.delete());
    });
   });
}