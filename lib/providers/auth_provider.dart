import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/services/auth_service.dart';
import '../utils/constants/snackbar.dart';

class AuthProvider with ChangeNotifier {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  // final RxBool isLoading = false.obs;
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  Future<void> signIn(BuildContext context) async {
    // Get.to(() => const LoadingPopup());
    if (!loginFormKey.currentState!.validate()) return;

    try {
      await AuthService().signInWithEmailAndPassword(
          context,
          emailTextEditingController.text.trim(),
          passwordTextEditingController.text.trim());
      if (context.mounted) {
        MySnackbar.showSuccess(context, "welcome to play world");
      }
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
    } catch (e) {
      if (context.mounted) {
        // Navigator.pop(context);
        MySnackbar.showError(context, e.toString());
      }
      log("SigninError");
    }
  }

  // void gooogleSignin() async {
  //   // Get.to(() => const LoadingPopup());
  //   try {
  //     // await AuthServicesitory().signInWithGoogle();
  //     emailTextEditingController.clear();
  //     passwordTextEditingController.clear();
  //   } catch (e) {
  //     MySnackbar.showError(e.toString());
  //     log("gooogle Signin Error");
  //   }
  // }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      log("Error: $e");
    }
  }

  void signOut() {
    _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
