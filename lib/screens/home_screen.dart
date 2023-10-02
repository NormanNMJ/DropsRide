import 'package:dropsride/screens/driver_home_screen.dart';
import 'package:dropsride/screens/rider/riderPage.dart';
import 'package:dropsride/screens/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../themeProvider/theme_provider.dart';
import 'driver/driverPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseReference _userRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          themeMode: ThemeMode.system,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<DatabaseEvent>(
            stream: _userRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final event = snapshot.data!;

                if (!event.snapshot.exists) {
                  // Handle the case where the snapshot doesn't exist
                  print('Snapshot not found.');
                  return Center(child: Text('Snapshot not found.'));
                }

                final dynamic snapshotValue = event.snapshot.value;

                if (snapshotValue == null) {
                  print('Snapshot value is null.');
                  return Center(child: Text('Snapshot value is null.'));
                }

                final isDriver = snapshotValue['isDriver'] ?? false;

                // Navigate to the appropriate page based on the isDriver value
                return isDriver ? RiderPage() : DriverPage();
              } else {
                print('No data available.');
                return Center(child: Text('No data available.'));
              }
            },
          ),
        ));
  }
}
