import 'dart:async';

import 'package:dropsride/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../constant/size.config.dart';
import '../global/global.dart';
import '../global/pageNavigator.dart';
import '../models/assistant_method.dart';
import '../screens/home_screen.dart';
import '../slides/slidesScreen.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      if (firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistanceMethods.readCurrentOnlineUserInfo()
            : null;
        PageNavigator.navigateToNextPage(context, const HomeScreen());
      } else {
        PageNavigator.navigateToNextPage(context, SplashScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset('images/light_bg.png', fit: BoxFit.cover,),
            Positioned(
                top: MediaQuery.of(context).size.height *0.3, // Adjust position based on screen size
                left: 0,
                right: 0,
                child:Center(
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.086,

                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(MediaQuery.of(context).size.height * 0.086),
                      child: Image.asset(
                        'images/splash/cs.gif',
                        fit: BoxFit.cover,
                        height: double.maxFinite,
                        width: double.maxFinite,
                      ),
                    ),
                  ),
                ),
            ),],
        ),
      ),
    );
  }
}
