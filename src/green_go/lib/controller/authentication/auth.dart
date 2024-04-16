import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';



class AuthService {
  late FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  DataBaseUsers dataBaseUsers = DataBaseUsers();


  void setFirebaseAuth(FirebaseAuth firebaseAuth) {
    _firebaseAuth = firebaseAuth;
    
  }

  void setDataBaseUsers(DataBaseUsers dataBaseUsers) {
    this.dataBaseUsers = dataBaseUsers;
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully logged in";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found: Double check your email";
      } else if (e.code == 'wrong-password') {
        return "Wrong password, try again";
      }
      return "Error: ${e.code}. Please try again";
    }
  }
  Future<String?> signUp(String email, String password, String username) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await dataBaseUsers.addUser(UserModel(result.user!.uid, username));
      return "Successfully registered";
    } on FirebaseAuthException catch (e) {
      _firebaseAuth.currentUser!.delete();
      if (e.code == 'weak-password') {
        return "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        return "Email is already in use";
      }
    } catch (e) {
      return "Error: $e. Please try again";
    }
    return "Something went wrong, please try again";
  }
  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
  Future deleteUser() async{
    try {
      dataBaseUsers.deleteUser(_firebaseAuth.currentUser!.uid);
      await _firebaseAuth.currentUser!.delete();
      return "Delete successful";
    } catch(e) {
      return "Invalid deletion";
    }
  }
}
