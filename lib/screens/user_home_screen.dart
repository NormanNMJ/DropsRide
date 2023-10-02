import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../animation/progressDialog.dart';
import '../authentication/login_screen.dart';
import '../authentication/userInfoPage.dart';
import '../constant/size.config.dart';
import '../global/global.dart';
import '../global/pageNavigator.dart';
import '../infoHandler/app_info.dart';
import '../models/active_nearby_available_drivers.dart';
import '../models/assistant_method.dart';
import '../models/geofire_assistant.dart';
import 'package:location/location.dart' as loc;

import 'select_destination_screen.dart';

class RiderScreen extends StatefulWidget {
  const RiderScreen({
    super.key,
  });

  @override
  State<RiderScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends State<RiderScreen> {
  bool rider = true;
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String statusText = "Now offline";
  bool isDriverActive = false;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      ReplacePageNavigator.navigateToNextPage(context, const LoginScreen());
      print('User signed out successfully');
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> _riderScaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponseFreeDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circlesSet = {};

  String userName = "";
  String userEmail = "";
  String? _address;

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  Future<void> locateYourPosition() async {
    Position? cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (cPosition != null) {
      LatLng latLngPosition = LatLng(cPosition.latitude, cPosition.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 15);

      await newGoogleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );

      String humanReadableAddress =
          await AssistanceMethods.searchAddressForGeographicCoOrdinates(
        cPosition,
        context,
      );

      print("This is our address: $humanReadableAddress");
    } else {
      // Handle case where user's location is not available
      print("User location not available.");
    }
  }

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
    print("This is our address" + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
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
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context,
              size: Size(
                0.5,
                0.5,
              ));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/person_logo.png")
          .then((value) {
        activeNearbyIcon = value;
      });
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

  // getAddressFromLatLng() async {
  //   try {
  //     GeoData data = await Geocoder2.getDataFromCoordinates(
  //         latitude: pickLocation!.latitude,
  //         longitude: pickLocation!.longitude,
  //         googleMapApiKey: mapkey);
  //     setState(() {
  //       Directions userPickUpAddress = Directions();
  //       userPickUpAddress.locationLatitude = pickLocation!.latitude;
  //       userPickUpAddress.locationLongitude = pickLocation!.longitude;
  //       userPickUpAddress.locationName = data.address;
  //
  //       Provider.of<AppInfo>(context, listen: false)
  //           .updatePickUpLocationAddress(userPickUpAddress);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
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

  @override
  void initState() {
    super.initState();

    print(_address);

    locateUserPosition();

    checkIfLocationPermissionIsAllowed();
  }



  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();
    SizeConfig.init(context);
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      key: _riderScaffoldState,
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
                      // Adjust the padding as needed
                      child: GestureDetector(
                        onTap: () {
                          setState(() {

                            updateIsDriver(false);
                            _riderScaffoldState.currentState!.closeDrawer();
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'images/driver_switch_icon.png',
                              // Replace with the correct path to your asset image
                              width: 30,
                              height: 30,
                            ),
                            const Text(
                              'Switch to Drive',
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
              text: 'Payment',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.schedule,
              text: 'Trip History',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.redeem,
              text: 'Free Trips',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.settings,
              text: 'Settings',
              destinationPage: UserInfoPage(),
            ),
            const DrawerList(
              icon: Icons.help,
              text: 'Support',
              destinationPage: UserInfoPage(),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
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
              locateUserPosition();
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

          // Align(
          //   alignment: Alignment.center,
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 35),
          //     child: Image.asset(
          //       "images/pick.png",
          //       width: 45,
          //       height: 45,
          //     ),
          //   ),
          // ),

          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _riderScaffoldState.currentState!.openDrawer();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  'images/menu_icon.svg', // Replace with your SVG asset path
                ),
              ),
            ),
          ),

          // Positioned widget for the bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        locateYourPosition();
                        locateUserPosition();
                        print('object');
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: SvgPicture.asset(
                        'images/images/icons/current-location.svg', // Replace with your SVG asset path
                      ),
                    ),
                  ),
                ),
                Container(
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
                                child: GestureDetector(
                                  onTap: () async {
                                    var responseFromSearchScreen =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectDestination()));

                                    if (responseFromSearchScreen ==
                                        "obtainedDropOff") {
                                      setState(() {
                                        openNavigationDrawer = false;
                                      });

                                      // Call drawPolyLineFromOriginToDestination only if the response indicates "obtainedDropOff"
                                      await drawPolyLineFromOriginToDestination(
                                          darkTheme);
                                    }
                                  },
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // RoundedTextField(
                                      //   hintText: Provider.of<AppInfo>(context)
                                      //               .userDropOffLocation !=
                                      //           null
                                      //       ? (Provider.of<AppInfo>(context)
                                      //                   .userDropOffLocation!
                                      //                   .locationName !=
                                      //               null
                                      //           ? (Provider.of<AppInfo>(context)
                                      //                       .userDropOffLocation!
                                      //                       .locationName!
                                      //                       .length >
                                      //                   24
                                      //               ? "${Provider.of<AppInfo>(context).userDropOffLocation!.locationName!.substring(0, 24)}..."
                                      //               : Provider.of<AppInfo>(
                                      //                       context)
                                      //                   .userDropOffLocation!
                                      //                   .locationName!)
                                      //           : "Your Destination")
                                      //       : "Your Destination",
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     ElevatedButton(
                                      //       onPressed: () {
                                      //         PageNavigator.navigateToNextPage(
                                      //             context,
                                      //             const PrecisePickUpScreen());
                                      //       },
                                      //       style: ElevatedButton.styleFrom(
                                      //           primary: darkTheme
                                      //               ? Colors.amber.shade400
                                      //               : Colors.blue,
                                      //           textStyle: const TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16,
                                      //           )),
                                      //       child: Padding(
                                      //         padding:
                                      //             const EdgeInsets.all(8.0),
                                      //         child: Text(
                                      //           "Change pick up",
                                      //           style: TextStyle(
                                      //             color: darkTheme
                                      //                 ? Colors.black
                                      //                 : Colors.white,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 10,
                                      //     ),
                                      //     ElevatedButton(
                                      //       onPressed: () {},
                                      //       style: ElevatedButton.styleFrom(
                                      //           primary: darkTheme
                                      //               ? Colors.amber.shade400
                                      //               : Colors.blue,
                                      //           textStyle: const TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16,
                                      //           )),
                                      //       child: Padding(
                                      //         padding:
                                      //             const EdgeInsets.all(8.0),
                                      //         child: Text(
                                      //           "Request ride",
                                      //           style: TextStyle(
                                      //             color: darkTheme
                                      //                 ? Colors.black
                                      //                 : Colors.white,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateDriverLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive == true) {
        Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }
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
