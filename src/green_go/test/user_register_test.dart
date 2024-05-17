
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/model/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/controller/database/database_users.dart';


import 'package:green_go/view/pages/register_page.dart';

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
  RegisterPageViewState registerPageViewState = RegisterPageViewState();

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    authService = AuthService();
    mockDataBaseUsers = MockDataBaseUsers();
    authService.setFirebaseAuth(firebaseAuth);
    authService.setDataBaseUsers(mockDataBaseUsers);
  });
  group('Register - ', () {
    test('Successfully registered', () async {
      //given
      final MockUser user = MockUser();
      final MockUserCredential userCredential = MockUserCredential();
      when(userCredential.user).thenReturn(user);
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'strongpassword',
      )).thenAnswer((_) async => userCredential);

      //when
      final result = await authService.signUp('new@example.com', 'strongpassword', 'newUser');

      //then
      expect(result, equals("Successfully registered"));
    });
    test('Weak password', () async {
      //given
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'weak',
      )).thenThrow(FirebaseAuthException(code: 'weak-password'));

      //when
      final result = await authService.signUp('new@example.com', 'weak', 'newUser');

      //then
      expect(result, equals("Password is too weak"));
    });

    test('Email already in use', () async {
      //given
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'existing@example.com',
        password: 'strongpassword',
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      //when
      final result = await authService.signUp('existing@example.com', 'strongpassword', 'existingUser');

      //then
      expect(result, equals("Email is already in use"));
    });

    test('Other errors', () async {
      //given
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'error@example.com',
        password: 'password123',
      )).thenThrow(Exception("Unexpected error"));

      //when
      final result = await authService.signUp('error@example.com', 'password123', 'errorUser');

      //then
      expect(result, equals("Error: Exception: Unexpected error. Please try again"));
    });
  });

  //REGISTER PAGE TEST

  group('Register Page test - ', () {
    test('isNotFilled() - not filled', () {
      expect(registerPageViewState.isNotFilled("", "email@example.com", "password", "password"), true);
      expect(registerPageViewState.isNotFilled("example", "", "password", "password"), true);
      expect(registerPageViewState.isNotFilled("example", "email@example.com", "", "password"), true);
      expect(registerPageViewState.isNotFilled("example", "email@example.com", "password", ""), true);
    });
    test('isNotFilled() - all filled', () {
      expect(registerPageViewState.isNotFilled("example", "email@example.com", "password", "password"), false);
    });
    test('isInvalidUsername() - invalid', () {
      expect(registerPageViewState.isInvalidUsername("aaaaaaaaaaaaaaaaaallll"), true);
      expect(registerPageViewState.isInvalidUsername("abcdefghijklmopqrstuvwxyz123"), true);
    });
    test('isInvalidUsername() - valid', () {
      expect(registerPageViewState.isInvalidUsername("amen"), false);
    });
    test('isInvalidEmail() - invalid', () {
      expect(registerPageViewState.isInvalidEmail("example.com"), true);
      expect(registerPageViewState.isInvalidEmail("example@ni"), true);
    });
    test('isInvalidEmail() - valid', () {
      expect(registerPageViewState.isInvalidEmail("example@example.com"), false);
    });
    test('diffPassword() - different', () {
      expect(registerPageViewState.diffPasswords("123", "321"), true);
      expect(registerPageViewState.diffPasswords("123", "123 "), true);
      expect(registerPageViewState.diffPasswords("", "123"), true);
      expect(registerPageViewState.diffPasswords("123", ""), true);
    });
    test('diffPassword() - different', () {
      expect(registerPageViewState.diffPasswords("123", "123"), false);
    });
  });

}
