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
void main() {
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

  group('Sign in - ', () {
    test('Successful', () async {
      //given
      when(firebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: '123456',
      )).thenAnswer((_) async => MockUserCredential()); // MockUserCredential should be defined or use a real UserCredential instance

      //when
      final result = await authService.signIn('test@example.com', '123456');

      //then
      expect(result, equals("Successfully logged in"));
    });

    test('User not found', () async {
      //given
      when(firebaseAuth.signInWithEmailAndPassword(
        email: 'wrong@example.com',
        password: 'incorrect',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      //when
      final result = await authService.signIn('wrong@example.com', 'incorrect');

      //then
      expect(result, equals("User not found: Double check your email"));
    });

    test('Wrong password', () async {
      //given
      when(firebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      //when
      final result = await authService.signIn('test@example.com', 'wrongpassword');

      //then
      expect(result, equals("Wrong password, try again"));
    });
  });
}
