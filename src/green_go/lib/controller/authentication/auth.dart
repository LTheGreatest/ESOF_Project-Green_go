import 'package:firebase_auth/firebase_auth.dart';
///import 'package:green_go/model/user_model.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? getCurrentUserID() {
    return auth.currentUser;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password')
        // ignore: curly_braces_in_flow_control_structures
        return 'Wrong password provided for that user.';

      return e.code;
    }

  }
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
    } catch (e) {
      return e.toString();
    }
    return null;
  }
  Future signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}
