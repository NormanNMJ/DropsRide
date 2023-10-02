import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import '../constant/size.config.dart';
import '../global/map_key.dart';
import '../global/pageNavigator.dart';
import '../infoHandler/app_info.dart';
import '../models/assistant_method.dart';
import '../models/directions.dart';


class PrecisePickUpScreen extends StatefulWidget {
  const PrecisePickUpScreen({super.key});

  @override
  State<PrecisePickUpScreen> createState() => _PrecisePickUpScreenState();
}

class _PrecisePickUpScreenState extends State<PrecisePickUpScreen> {


  double bottomPaddingOfMap = 0;
  Position? userCurrentPosition;
  LatLng? pickLocation;
  loc.Location location = loc.Location();

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();


  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
    LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
    await AssistanceMethods.searchAddressForGeographicCoOrdinates(
        userCurrentPosition!, context);

  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapkey);
      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false)
            .updatePickUpLocationAddress(userPickUpAddress);
      });
    } catch (e) {
      print(e);
    }
  }




  @override
  Widget build(BuildContext context) {

    SizeConfig.init(context);
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,

            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {});
              locateUserPosition();
            },

            onCameraMove: (CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              getAddressFromLatLng();
            },

          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Image.asset(
                "images/pick.png",
                width: 45,
                height: 45,
              ),
            ),
          ),
           Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: darkTheme ? Colors.white : Colors.amber,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                RoundedTextField(
                                  hintText: Provider.of<AppInfo>(context)
                                      .userPickUpLocation !=
                                      null
                                      ? (Provider.of<AppInfo>(context)
                                      .userPickUpLocation!
                                      .locationName !=
                                      null
                                      ? (Provider.of<AppInfo>(context)
                                      .userPickUpLocation!
                                      .locationName!
                                      .length >
                                      24
                                      ? "${Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0, 24)}..."
                                      : Provider.of<AppInfo>(
                                      context)
                                      .userPickUpLocation!
                                      .locationName!)
                                      : "Not Getting Address")
                                      : "Not Getting Address",
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RoundedTextField(
                                  hintText: Provider.of<AppInfo>(context)
                                      .userDropOffLocation !=
                                      null
                                      ? (Provider.of<AppInfo>(context)
                                      .userDropOffLocation!
                                      .locationName !=
                                      null
                                      ? (Provider.of<AppInfo>(context)
                                      .userDropOffLocation!
                                      .locationName!
                                      .length >
                                      24
                                      ? "${Provider.of<AppInfo>(context).userDropOffLocation!.locationName!.substring(0, 24)}..."
                                      : Provider.of<AppInfo>(
                                      context)
                                      .userDropOffLocation!
                                      .locationName!)
                                      : "Your Destination")
                                      : "Your Destination",
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ), // Empty container
        ],
      ),
    );
  }
}
class RoundedTextField extends StatelessWidget {
  final String? hintText;

  const RoundedTextField({
    Key? key,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      enabled: false,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.location_on),
        hintText: hintText,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when not focused
          ),
        ),
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (value) {
        // Add your validation logic here
        return null; // Return null if validation passes
      },
    );
  }
}


