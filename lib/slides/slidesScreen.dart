import 'package:dropsride/constant/colors.dart';
import 'package:dropsride/global/pageNavigator.dart';
import 'package:dropsride/themeProvider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../authentication/signUp_screen.dart';
import '../constant/gaps.dart';
import '../constant/sizes.dart';
import '../constant/size.config.dart';

void main() {
  runApp(MaterialApp(home: SlideScreen()));
}

class SlideScreen extends StatefulWidget {
  @override
  _SlideScreenState createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final List<SlidePage> _pages = [
      SlidePage(
        onboard: 'images/onboarding/onboard_1.png',
        description: 'We provide the \n best services just \n for you',
        textButton: () {
          // Navigate to the sign-up page
          PageNavigator.navigateToNextPage(context, SignUpScreen());
        },
      ),
      const SlidePage(
        onboard: 'images/onboarding/onboard_2.png',
        description: 'Affordable and \n convenient rides',
      ),
      const SlidePage(
        onboard: 'images/onboarding/onboard_3.png',
        description: 'Lets Take you to \n your desired \n Destination.',
      ),
    ];
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      //backgroundColor: darkTheme ? MyThemes.darkTheme : MyThemes.lightTheme,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DotsIndicator(
                    dotsCount: _pages.length,
                    position: _currentIndex.toInt(),
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      color: darkTheme
                          ? AppColors.backgroundColorLight
                          : AppColors.backgroundColorDark,
                      activeColor: darkTheme
                          ? AppColors.backgroundColorLight
                          : AppColors
                              .backgroundColorDark, // Set active color to yellow
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Positioned(
                    bottom: AppSizes.padding * 3,
                    width: SizeConfig.screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.padding * 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.p12),
                          ),
                          elevation: AppSizes.p8,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.buttonHeight / 2.9,
                          ),
                        ),
                        onPressed: () {
                              if (_currentIndex < _pages.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              } else {
                                PageNavigator.navigateToNextPage(context, SignUpScreen());
                              }
                        },
                        child: Text(
                          'Next',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontSize: SizeConfig.screenHeight * 0.026,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.secondaryColor,
                                  ),
                        ),
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (_currentIndex < _pages.length - 1) {
                    //       _pageController.nextPage(
                    //         duration: const Duration(milliseconds: 500),
                    //         curve: Curves.ease,
                    //       );
                    //     } else {
                    //       PageNavigator.navigateToNextPage(context, SignUpScreen());
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     primary: darkTheme ? Colors.amber : Colors.black,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //   ),
                    //   child: SizedBox(
                    //     width: MediaQuery
                    //         .of(context)
                    //         .size
                    //         .width * 0.8, // 80% of screen width
                    //
                    //     child: Center(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(15.0),
                    //         child: Text(
                    //           'Next',
                    //           style: TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //             color: Theme
                    //                 .of(context)
                    //                 .brightness == Brightness.dark
                    //                 ? Colors.black
                    //                 : Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlidePage extends StatelessWidget {
  final String onboard;
  final String description;
  final VoidCallback? textButton;

  const SlidePage({
    required this.onboard,
    required this.description,
    this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: AppSizes.padding,
          right: AppSizes.padding,
          child: textButton != null
              ? TextButton(
                  onPressed: textButton,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hSizedBox10,
              CircleAvatar(
                backgroundImage: AssetImage(onboard),
                radius: 120.0,
              ),
              hSizedBox6,
              Text(
                description,

                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: SizeConfig.screenHeight * 0.026,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),

                // textAlign: TextAlign.center,
                // style: const TextStyle(
                //   fontSize: 50.0,
                //   fontWeight: FontWeight.bold,
                //   color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
