import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';
import '../data/services/user_service.dart';
import '../feature/auth/login_screen.dart';
import '../feature/home/home_screen.dart';
import '../utils/constants/snackbar.dart';

class AuthProvider with ChangeNotifier {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    if (emailTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty) {
      MySnackbar.showError(context, "Please fill all the fields");
      return;
    }
    try {
      await AuthService().signInWithEmailAndPassword(
          context,
          emailTextEditingController.text.trim(),
          passwordTextEditingController.text.trim());
      if (context.mounted) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        MySnackbar.showSuccess(context, "Welcome to play world");
      }
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
    } catch (e) {
      if (context.mounted) {
        MySnackbar.showError(context, e.toString());
      }
      log("SigninError");
    }
  }

  final fullNameText = TextEditingController();
  final phoneNumberText = TextEditingController();
  final emailText = TextEditingController();
  final dobText = TextEditingController();
  final passwordText = TextEditingController();
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    _isChecked = value;
    log("_isChecked: $_isChecked");
    notifyListeners();
  }

  void signup(BuildContext context) async {
    if (!signupFormKey.currentState!.validate()) return;
    signupFormKey.currentState!.save();
    log("signup isChecked: $_isChecked");
    try {
      if (!_isChecked) {
        MySnackbar.showError(context, "Need to accept the privacy & policy");
        return;
      }
      log(' Get.to(() => const LoadingPopup());');

      final userCredential = await AuthService().registerWithEmailAndPassword(
          emailText.text, passwordText.text.trim());
      final user = UserModel(
        id: userCredential.user!.uid,
        name: fullNameText.text.trim(),
        number: phoneNumberText.text.trim(),
        email: emailText.text.trim(),
        profile: '',
      );
      await UserService().saveUserRecord(user, userCredential.user!.uid);
      if (context.mounted) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      }

      fullNameText.clear();
      phoneNumberText.clear();
      emailText.clear();
      dobText.clear();
      passwordText.clear();
      isChecked = false;
      signupFormKey.currentState!.reset();
    } catch (e) {
      log("Error: $e");
    }
  }

  void signOut(BuildContext context) {
    _auth.signOut();
    _user = null;
    if (context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    notifyListeners();
  }
}
