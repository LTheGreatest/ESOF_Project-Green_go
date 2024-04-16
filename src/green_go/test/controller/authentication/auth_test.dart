import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>()])
void main() {
  FirebaseAuth firebaseAuth = MockFirebaseAuth();
  AuthService authService = AuthService();

  test('Sign in - succeeded', () {
    when(firebaseAuth.signInWithEmailAndPassword(
      email: 'test@example.com',
      password: '123456',
    )).thenAnswer();
    authService.setFirebaseAuth(firebaseAuth);
    final result = authService.signIn('test@example.com', '123456');
    expect(result, "Successfully logged in");
  });
}