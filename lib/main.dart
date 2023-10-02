
import 'package:dropsride/authentication/welcome_screen.dart';
import 'package:dropsride/errors/errorScreen.dart';
import 'package:dropsride/infoHandler/app_info.dart';
import 'package:dropsride/screens/home_screen.dart';
import 'package:dropsride/slides/slidesScreen.dart';
import 'package:dropsride/splashScreen/splash_screen.dart';
import 'package:dropsride/splashScreen/startup_Screen.dart';
import 'package:dropsride/themeProvider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropsride/global/global.dart';

import 'models/authModel.dart'; // Assuming this is where AuthModel is located

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider(create:
        (context) => AppInfo(),
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const StartUpScreen(),
      ),);
  }
}


