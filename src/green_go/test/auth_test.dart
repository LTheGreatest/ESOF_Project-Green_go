import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/model/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'auth_test.mocks.dart';
import 'package:green_go/controller/database/database_users.dart';


class MockUserCredential extends Mock implements UserCredential {}
class MockDataBaseUsers extends Mock implements DataBaseUsers {}
class MockUser extends Mock implements User {}


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
      when(firebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: '123456',
      )).thenAnswer((_) async => MockUserCredential()); // MockUserCredential should be defined or use a real UserCredential instance

      final result = await authService.signIn('test@example.com', '123456');
      expect(result, equals("Successfully logged in"));
    });

    test('User not found', () async {
      when(firebaseAuth.signInWithEmailAndPassword(
        email: 'wrong@example.com',
        password: 'incorrect',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final result = await authService.signIn('wrong@example.com', 'incorrect');
      expect(result, equals("User not found: Double check your email"));
    });

    test('Wrong password', () async {
      when(firebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await authService.signIn('test@example.com', 'wrongpassword');
      expect(result, equals("Wrong password, try again"));
    });
  });
  group('AuthService signUp Tests', () {
    test('signUp - Successfully registered', () async {
      final MockUser user = MockUser();
      when(user.uid).thenReturn('123');
      final MockUserCredential userCredential = MockUserCredential();
      when(userCredential.user).thenReturn(user);
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'strongpassword',
      )).thenAnswer((_) async => userCredential);
      when(mockDataBaseUsers.addUser(UserModel('new@example.com', 'strongpassword'))).thenAnswer((_) async {});

      final result = await authService.signUp('new@example.com', 'strongpassword', 'newUser');
      expect(result, equals("Successfully registered"));
    }); //se eu apagar este teste,passa o ultimo hehe

    test('signUp - Weak password', () async {
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'weak',
      )).thenThrow(FirebaseAuthException(code: 'weak-password'));

      final result = await authService.signUp('new@example.com', 'weak', 'newUser');
      expect(result, equals("Password is too weak"));
    });

    test('signUp - Email already in use', () async {
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'existing@example.com',
        password: 'strongpassword',
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await authService.signUp('existing@example.com', 'strongpassword', 'existingUser');
      expect(result, equals("Email is already in use"));
    });

    test('signUp - Other errors', () async {
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: 'error@example.com',
        password: 'password123',
      )).thenThrow(Exception("Unexpected error"));

      final result = await authService.signUp('error@example.com', 'password123', 'errorUser');
      expect(result, equals("Error: Exception: Unexpected error. Please try again"));
    });
  });
}
