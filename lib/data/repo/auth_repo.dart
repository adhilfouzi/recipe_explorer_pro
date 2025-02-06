import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../handle/firebase_exceptionhandler.dart';
import 'user_repo.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await UserRepo()
          .fetchUserdetails(userCredential.user!.uid)
          .whenComplete(() {
        log("fetch User details");
      });

      // if (user.isUser) {
      //   // Navigate to the bottom navigation bar widget
      //   // Get.offAll(() => const MyBottomNavigationBar());
      //   log("SigninSuccess");
      // } else {}
    } catch (e) {
      throw ExceptionHandler.handleException(e);
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

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       log("GoogleSignIn canceled by user");
  //       Get.back();
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     final user =
  //         await UserRepository().fetchUserdetails(userCredential.user!.uid);

  //     if (user.isUser) {
  //       Get.offAll(() => const MyBottomNavigationBar());
  //       await UserController().getUserRecord();
  //       log("Google SignIn Success ");
  //       MySnackbar.showSuccess("welcome to play world");
  //     } else {
  //       final newUser = UserModel(
  //         id: userCredential.user!.uid,
  //         name: userCredential.user!.displayName ?? 'N/A',
  //         number: userCredential.user!.phoneNumber ?? 'N/A',
  //         email: userCredential.user!.email ?? '',
  //         profile: '',
  //         isUser: true,
  //       );
  //       await UserRepository()
  //           .saveUserRecord(newUser, userCredential.user!.uid);
  //       await UserController().getUserRecord();

  //       Get.offAll(() => const MyBottomNavigationBar());
  //       MySnackbar.showSuccess("welcome to play world");
  //       log("Google SignUp Success");
  //     }
  //   } catch (e) {
  //     log("GoogleSignInError: $e");
  //     Get.back();
  //     MySnackbar.showError('Google Sign-In failed. Please try again.');
  //     throw ExceptionHandler.handleException(e);
  //   }
  // }
}
