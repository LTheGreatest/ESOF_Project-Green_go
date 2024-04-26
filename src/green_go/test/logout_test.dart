import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_go/controller/authentication/auth.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'auth_test.mocks.dart';
import 'package:green_go/controller/database/database_users.dart';


class MockUserCredential extends Mock implements UserCredential {}
class MockDataBaseUsers extends Mock implements DataBaseUsers {}
class MockUser extends Mock implements User {}

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
    
    test('logout successful', () {
      //when(firebaseAuth.signOut()).
    });

    test('logout - faild', () async {
      when(firebaseAuth.signOut()).thenThrow("error message");
      final result = await authService.signOut();

      expect(result, equals("error message"));
    });
    
  });
}