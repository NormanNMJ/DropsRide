import 'dart:async';

import 'package:dropsride/authentication/welcome_screen.dart';
import 'package:dropsride/global/global.dart';
import 'package:dropsride/global/pageNavigator.dart';
import 'package:dropsride/models/assistant_method.dart';
import 'package:dropsride/screens/home_screen.dart';
import 'package:dropsride/slides/slidesScreen.dart';
import 'package:dropsride/themeProvider/theme_provider.dart';
import 'package:flutter/material.dart';

import '../animation/progressDialog.dart';
import '../constant/colors.dart';
import '../constant/size.config.dart';
import '../constant/sizes.dart';


class
SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<String> texts = ['Hello!', 'Bawo!', 'Sannu!', 'Nnọọ!'];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();

  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        currentIndex = (currentIndex + 1) % texts.length;
        _startAnimation();
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    bool darkTheme =  Theme.of(context).brightness == Brightness.dark; // Set your dark theme preference here
    String imagePath = Theme.of(context).brightness == Brightness.dark
        ? 'images/dark_bg.png'
        : 'images/light_bg.png';

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),



              // Animated texts
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 2500),
                  opacity: 1,
                  child: Center(
                    child: Visibility(
                      visible: true,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.09,
                              fontWeight: FontWeight.w900,
                              color: darkTheme
                                  ? AppColors.backgroundColorLight
                                  : AppColors.backgroundColorDark,
                            ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              texts[currentIndex],
                              key: ValueKey<int>(currentIndex),
                              style:  TextStyle(
                                fontSize: SizeConfig.screenHeight * 0.09,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Animated button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1500),
                bottom: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 1700),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.p12),
                        ),
                        elevation: AppSizes.p8,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.buttonHeight / 2.9,
                        ),
                      ),
                      onPressed: () {
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        // builder: ((context) => const IntroScreen())));
                        PageNavigator.navigateToNextPage(context, SlideScreen());
                        // if (controller.isDarkMode.value) {
                        //   controller.changeTheme(DropsrideTheme.dropsrideLightTheme);
                        //   controller.saveTheme(false);
                        //   controller.updateMode();
                        // } else {
                        //   controller.changeTheme(DropsrideTheme.dropsrideDarkTheme);
                        //   controller.saveTheme(true);
                        //   controller.updateMode();
                        // }
                      },
                      child: Text('Get Started',
                          style:
                          Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: SizeConfig.screenHeight * 0.026,
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondaryColor,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
