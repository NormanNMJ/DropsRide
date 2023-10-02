
import 'package:dropsride/authentication/signUp_screen.dart';
import 'package:flutter/material.dart';

import '../global/pageNavigator.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
    bool darkTheme = true; // Set your dark theme preference here

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              // Background image
              Positioned(
                child: Image.asset(
                  darkTheme ? 'images/splash/dark_bg.png' : 'images/splash/light_bg.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // App logo
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 1500),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.096,
                      backgroundColor: darkTheme ? Colors.grey[200] : Colors.grey[800],
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.09,
                        backgroundImage: const AssetImage('images/splash/cs.gif'),
                      ),
                    ),
                  ),
                ),
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
                          fontSize: MediaQuery.of(context).size.height * 0.09,
                          fontWeight: FontWeight.w900,
                          color: darkTheme ? Colors.white : Colors.black,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            texts[currentIndex],
                            key: ValueKey<int>(currentIndex),
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Animated buttons

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkTheme
                            ? Colors.amber.shade400
                            : Colors.blue,
                        onPrimary:
                        darkTheme ? Colors.black : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        PageNavigator.navigateToNextPage(context, LoginScreen());
                      },
                      child: const Text('Login'),
                    ),

                    SizedBox(height: 20,),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkTheme
                            ? Colors.amber.shade400
                            : Colors.blue,
                        onPrimary:
                        darkTheme ? Colors.black : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        PageNavigator.navigateToNextPage(context, SignUpScreen());

                      },
                      child: const Text('Register'),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
