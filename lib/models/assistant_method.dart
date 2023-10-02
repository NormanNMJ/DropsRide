import 'package:dropsride/global/global.dart';
import 'package:dropsride/global/map_key.dart';
import 'package:dropsride/models/directions.dart';
import 'package:dropsride/models/request_assistant.dart';
import 'package:dropsride/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import 'direction_details_info.dart';

class AssistanceMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    String humanReadAbleAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred. Failed. No Response.") {
      humanReadAbleAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadAbleAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadAbleAddress;
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapkey";
    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);
    // if(responseDirectionApi == "Error Occurred. Failed. No Response.")
    // {
    //   return null;
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_point = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];


    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;




  }


  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTravelledFareAmountPerMinute = (directionDetailsInfo.duration_value! /60) * 0.1;
    double distanceTraveledFareAmountPerKilometer =(directionDetailsInfo.duration_value!/ 1000) * 0.1;


    double totalFareAmount  = timeTravelledFareAmountPerMinute * distanceTraveledFareAmountPerKilometer;
    
    return double.parse(totalFareAmount.toStringAsFixed(1));
  }
}
