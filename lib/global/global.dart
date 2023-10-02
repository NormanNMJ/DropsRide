
import 'dart:async';

import 'package:dropsride/global/pageNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import '../models/direction_details_info.dart';
import '../models/driver_data.dart';
import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;
String userDropOffAddress = "";

DriverData onlineDriverData = DriverData();

String? driverVehicleType ="";

StreamSubscription<Position>? streamSubscriptionPosition;

StreamSubscription<Position>? streamSubscriptionDriverLivePosition;


DirectionDetailsInfo? tripDirectionDetailsInfo;


Position? driverCurrentPosition;



UserModel? userModelCurrentInfo;


void updateIsDriver(bool isDriver) {
  DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(FirebaseAuth.instance.currentUser!.uid);

  userRef.update({
    'isDriver': isDriver,
  }).then((_) {
    print('isDriver updated successfully to $isDriver');
  }).catchError((error) {
    print('Failed to update isDriver: $error');
  });
}


class DrawerList extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget destinationPage;

  const DrawerList({
    super.key,
    required this.icon,
    required this.text,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            icon,
            size: 35,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        // Add your drawer item 1 handling here
        PageNavigator.navigateToNextPage(context, destinationPage);
      },
    );
  }
}





class RowText extends StatelessWidget {
  final SvgPicture image;
  final double percent;
  final String text;

  RowText({required this.text, required this.image, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            image,
            Text(
              percent.toString(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
