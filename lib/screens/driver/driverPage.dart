import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../authentication/forgetPassword.dart';
import '../../authentication/userInfoPage.dart';
import '../../global/global.dart';
import '../../infoHandler/app_info.dart';
import '../../models/active_nearby_available_drivers.dart';
import '../../models/assistant_method.dart';
import '../../models/geofire_assistant.dart';
import '../../vehicle/car_info_screen.dart';
import '../select_destination_screen.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  bool _bottomSheetVisible = false;

  get darkTheme => null;

  void _toggleBottomSheetVisibility() {
    setState(() {
      _bottomSheetVisible = !_bottomSheetVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your main content goes here
          GoogleMap(
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            polylines: polyLineSet,
            initialCameraPosition: _kGooglePlex,
            markers: markerSet,
            circles: circlesSet,

            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {});
              locateDriverPosition();
            },

            // onCameraMove: (CameraPosition? position) {
            //   if (pickLocation != position!.target) {
            //     setState(() {
            //       pickLocation = position.target;
            //     });
            //   }
            // },
            // onCameraIdle: () {
            //   getAddressFromLatLng();
            // },
          ),


          // Positioned widget for the SVG icon
          Positioned(
            top: 50,
            left: 20,
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: SvgPicture.asset(
                    'images/menu_icon.svg', // Replace with your SVG asset path
                    color:  Colors.red,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.amber,
        // Add your drawer content here
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Implement onTap functionality
                          setState(() {
                            updateIsDriver(true);
                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'images/driver_switch_icon.png',
                              width: 30,
                              height: 30,
                            ),
                            const Text(
                              'Switch to Rider',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 10,
                    left: 20,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage('images/person_logo.png'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Rating: 4.5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const DrawerList(
              icon: Icons.credit_card_outlined,
              text: 'Profile',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.schedule,
              text: 'Vehicle',
              destinationPage: CarInfoScreen(),
            ),
            const DrawerList(
              icon: Icons.redeem,
              text: 'Earnings',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.settings,
              text: 'Trip History',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.help,
              text: 'Settings',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.help,
              text: 'Support',
              destinationPage: UserInfoPage(),
            ),
            // ... Rest of your drawer content
          ],
        ),
      ),

    );
  }

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circlesSet = {};
  Position? userCurrentPosition;

  bool activeNearbyDriverKeysLoaded = false;

  LocationPermission? _locationPermission;


  String statusText = "Now Offline";
  BitmapDescriptor? activeNearbyIcon;



  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }


  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
    await AssistanceMethods.searchAddressForGeographicCoOrdinates(
        driverCurrentPosition!, context);
    print("This is our address" + humanReadableAddress);

    // initializeGeoFireListener();
  }


  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callBack = map["callBack"];

        switch (callBack) {
        //whenever any drive is active

          case Geofire.onKeyEntered:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
            ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongitude = map["longitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeoFireAssistant.activeNearByAvailableDriversList
                .add(activeNearByAvailableDrivers);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUserMap();
            }
            break;

        //whenever driver become non active/online

          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map["key"]);
            displayActiveDriversOnUserMap();
            break;

        // whenever driver move, update location
          case Geofire.onKeyMoved:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
            ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongitude = map["longitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeoFireAssistant.updateActiveNearByAvailableDriverLocation(
                activeNearByAvailableDrivers);
            displayActiveDriversOnUserMap();
            break;

        //display online drivers on user map

          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUserMap();
            break;
        }
      }
      setState(() {});
    });
  }

  displayActiveDriversOnUserMap() {
    setState(() {
      markerSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearByAvailableDrivers eachDriver
      in GeoFireAssistant.activeNearByAvailableDriversList) {
        LatLng eachDriverActivePosition =
        LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }
      setState(() {
        markerSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon != null) {
      ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, "images/person_logo.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  readCurrentDriverInformation() async {
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)['id'];
        onlineDriverData.name = (snap.snapshot.value as Map)['name'];
        onlineDriverData.email = (snap.snapshot.value as Map)['email'];
        onlineDriverData.phone = (snap.snapshot.value as Map)['phone'];
        onlineDriverData.address = (snap.snapshot.value as Map)['address'];
        onlineDriverData.car_number =
        (snap.snapshot.value as Map)['car_details']["car_number"];
        onlineDriverData.car_model =
        (snap.snapshot.value as Map)['car_details']["car_model"];
        onlineDriverData.car_color =
        (snap.snapshot.value as Map)['car_details']["car_color"];

        driverVehicleType =
        (snap.snapshot.value as Map)['car_details']["car_type"];
      }
    });
  }


  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    print(originPosition);
    print(destinationPosition);
    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) =>
    //         ProgressDialog(
    //           message: "Please wait",
    //         ));
    var directionDetailsInfo =
    await AssistanceMethods.obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodePolyLinePointsResultList =
    pPoints.decodePolyline(directionDetailsInfo.e_point!);

    pLineCoordinatedList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: darkTheme ? Colors.red : Colors.blue,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
          LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast:
          LatLng(originLatLng.latitude, destinationLatLng.longitude));
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
      InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        infoWindow: InfoWindow(
            title: destinationPosition.locationName, snippet: "Destination"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ));

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
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
