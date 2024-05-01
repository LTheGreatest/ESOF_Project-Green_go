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

  group('logout tests', () { 
    
    test('logout successful', () async {
      //when
      final result = await authService.signOut();

      //then
      expect(result, equals("logout_success"));

    });

    test('logout - faild', () async {
      //given
      when(firebaseAuth.signOut()).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      //when
      final result = await authService.signOut();

      //then
      expect(result, equals('user-not-found'));
    });
    
  });
}