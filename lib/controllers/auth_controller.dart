import 'package:firebase_auth/firebase_auth.dart';
import 'package:ritammuddatask/controllers/database_controller.dart';
import 'package:ritammuddatask/models/user_model.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signInWithMailPass(String mail, String pass) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: mail, password: pass)
          .timeout(networkTimeout);

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return null;
      } else {
        throw "Something went wrong (${e.code})";
      }
    }
  }

  Future<String?> registerWithMailPass(
      String name, String mail, String pass) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: mail, password: pass)
          .timeout(networkTimeout);
      final User? user = userCredential.user;

      if (user != null) {
        await DatabaseController(uid: user.uid).setInitialUserData(UserModel(
          uid: user.uid,
          name: name,
          email: mail,
        ));
      }
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw "Something went wrong (${e.code})";
    }
  }

  Future<bool?> forgetPass(String mail) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: mail);
      return true;
    } on FirebaseAuthException catch (e) {
      throw "Something went wrong (${e.code})";
    }
  }

  Future<bool?> resetPass(String code, String pass) async {
    try {
      await _firebaseAuth.confirmPasswordReset(code: code, newPassword: pass);
      return true;
    } on FirebaseAuthException catch (e) {
      throw "Something went wrong (${e.code})";
    }
  }

  Future<bool?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      throw "Something went wrong (${e.code})";
    }
  }

  Future<String?> currentUser() async {
    try {
      return _firebaseAuth.currentUser?.uid;
    } on FirebaseAuthException catch (e) {
      throw "Something went wrong (${e.code})";
    }
  }

  final Duration networkTimeout = const Duration(seconds: 10);
}
