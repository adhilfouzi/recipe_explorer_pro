import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';
import '../data/services/user_service.dart';
import '../feature/auth/login_screen.dart';
import '../feature/home/home_screen.dart';
import '../utils/constants/images.dart';
import '../utils/constants/snackbar.dart';
import 'user_provider.dart';

class AuthProvider with ChangeNotifier {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    final userPro = Provider.of<UserProvider>(context, listen: false);
    if (emailTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty) {
      MySnackbar.showError(context, "Please fill all the fields");
      return;
    }
    try {
      var user = await AuthService().signInWithEmailAndPassword(
          emailTextEditingController.text.trim(),
          passwordTextEditingController.text.trim());

      if (user.email == '') {
        if (context.mounted) {
          MySnackbar.showError(context, "No User Found, Sign Up First");
        }
        return;
      }

      if (context.mounted) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      await userPro.addUser(user);
    } catch (e, s) {
      log("SigninError $e :- $s");
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    final userPro = Provider.of<UserProvider>(context, listen: false);
    try {
      var user = await AuthService().signInWithGoogle();

      if (user.email == '') {
        if (context.mounted) {
          MySnackbar.showError(context, "No User Found, Sign Up First");
        }
        return;
      }

      await userPro.addUser(user);
      if (context.mounted) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        MySnackbar.showSuccess(context, "Welcome to play world");
      }
    } catch (e) {
      log("SigninError $e");
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
    final userPro = Provider.of<UserProvider>(context, listen: false);

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
        profile: Images.avatar,
      );
      await UserService().saveUserRecord(user, userCredential.user!.uid);

      // Add user data to UserProvider
      await userPro.addUser(user);

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

  void signOut(BuildContext context) async {
    final userPro = Provider.of<UserProvider>(context, listen: false);

    _auth.signOut();
    _user = null;
    if (context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    await userPro.logoutUser();
    notifyListeners();
  }
}
