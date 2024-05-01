import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:green_go/controller/database/database_users.dart';

import 'delete_user_test.mocks.dart';





@GenerateNiceMocks([MockSpec<FirebaseAuth>(),MockSpec<DataBaseUsers>() ,MockSpec<User>()])

void main(){
  late MockFirebaseAuth firebaseAuth;
  late AuthService authService;
  late MockDataBaseUsers mockDataBaseUsers;
  late MockUser mockUser;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    authService = AuthService();
    mockDataBaseUsers = MockDataBaseUsers();
    mockUser = MockUser();
    authService.setFirebaseAuth(firebaseAuth);
    authService.setDataBaseUsers(mockDataBaseUsers);
  });

  group('delete tests', ()  {
    test('delete faild source: database', () async {
      when(mockDataBaseUsers.deleteUser("failtest")).thenThrow("deletion from database faild");

      final result = await authService.deleteUser();

      expect(result, equals("Invalid deletion from database"));
    });

    

    test('delete - faild source: auth', () async {
      when(mockUser.uid).thenReturn('123');
      when(firebaseAuth.currentUser).thenReturn(mockUser);
      
      
      when(mockUser.delete()).thenThrow(FirebaseAuthException(code: 'user-not-found'));
      final result= await authService.deleteUser();
      expect(result, equals('user-not-found'));
    });
    

    test('deletion success',  () async{
      when(mockUser.uid).thenReturn('123');
      when(firebaseAuth.currentUser).thenReturn(mockUser);
      final result =await authService.deleteUser();
      verify(mockDataBaseUsers.deleteUser('123'));
      verify(firebaseAuth.currentUser?.delete());

      expect(result, equals("Delete successful"));
    });

    test('deletion after update', () async {
      when(mockUser.uid).thenReturn('123');
      when(firebaseAuth.currentUser).thenReturn(mockUser);
      mockDataBaseUsers.updateUserProfile('123', 'teste', 'teste', 'teste', DateTime.now());
      final result =await authService.deleteUser();
      verify(mockDataBaseUsers.deleteUser('123'));
      verify(firebaseAuth.currentUser?.delete());

      expect(result, equals("Delete successful"));

    });
   });
}

