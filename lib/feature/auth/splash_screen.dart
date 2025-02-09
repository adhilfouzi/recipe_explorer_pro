import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn(context);
    // Get.put(UserController());
    // Get.put(TurfController());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height),
            Image.asset(Images.logo, width: height * 1.5),
            SizedBox(height: height),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkUserLoggedIn(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log("User is not logged in");
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      log("User is logged in", error: "User is logged in");
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }
}
