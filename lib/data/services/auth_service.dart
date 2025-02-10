import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../handle/firebase_exceptionhandler.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get authUser => _auth.currentUser;

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a new user with email and password
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await UserService().fetchUserdetails(userCredential.user!.uid);
    } catch (e) {
      log(ExceptionHandler.handleException(e));
      return UserModel.empty();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<void> userLogout() async {
    try {
      log(_auth.currentUser!.uid.toString());
      await _auth.signOut();
      // await _googleSignIn.signOut();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        log("GoogleSignIn canceled by user");
        // Get.back();
        return UserModel.empty();
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return await UserService().fetchUserdetails(userCredential.user!.uid);
    } catch (e) {
      log("GoogleSignInError: $e");
      throw ExceptionHandler.handleException(e);
    }
  }
}
