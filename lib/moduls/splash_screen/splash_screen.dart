import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodapp/core/resources/image_manager.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:foodapp/moduls/onboarding/view/onboarding_view.dart';

import '../../app/dependency_injection.dart';
import '../../app/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppPreferences _preferences = inectance<AppPreferences>();
  bool? isLogin;
  bool? isSkepedOnboarding;

  Timer? countTimer;
  startTimer() {
    countTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => Navigator.of(context).pushReplacementNamed(
            isSkepedOnboarding == true
                ? Routes.mainScreen
                : Routes.onboardingScreen));
  }

  @override
  void initState() {
    isLogin = _preferences.getIsLogin() ?? false;
    isSkepedOnboarding = _preferences.getIsSkepedOnboarding() ?? false;
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromARGB(181, 255, 255, 255),
            image: DecorationImage(
                image: AssetImage(ImageManager.splashBackground),
                fit: BoxFit.cover)),
        child: Center(
          child: SizedBox(
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    countTimer?.cancel();
    super.dispose();
  }
}
