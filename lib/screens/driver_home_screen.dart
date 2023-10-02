import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../authentication/userInfoPage.dart';
import '../constant/colors.dart';
import '../global/global.dart';
import '../global/pageNavigator.dart';
import '../models/active_nearby_available_drivers.dart';
import '../models/assistant_method.dart';
import '../models/geofire_assistant.dart';
import '../vehicle/car_info_screen.dart';

class DriverScreen extends StatefulWidget {
  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final GlobalKey<ScaffoldState> _driverScaffoldState =
      GlobalKey<ScaffoldState>();

  Set<Polyline> polyLineSet = {};
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocation = Geolocator();
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;

  Set<Marker> markerSet = {};
  Set<Circle> circlesSet = {};

  String statusText = "Now Offline";
  BitmapDescriptor? activeNearbyIcon;

  Position? userCurrentPosition;

  bool activeNearbyDriverKeysLoaded = false;

  LocationPermission? _locationPermission;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLocationPermissionIsAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _driverScaffoldState,
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
                            updateIsDriver(false);
                            _driverScaffoldState.currentState!.closeDrawer();
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
            DrawerList(
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
      body: Stack(
        children: [
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
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _driverScaffoldState.currentState!.openDrawer();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  'images/menu_icon.svg',
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // _goToDriversProfilePage();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('images/person_logo.png'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  statusText != "Now Online"
                      ? GestureDetector(
                          onTap: () {
                            // Implement onTap functionality
                          },
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(16.0),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Go Online',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Column(
                      children: [
                        statusText != "Now Online"
                            ? Container()
                            : const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    "You are now Online",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RowText(
                                text: 'Acceptance',
                                image: SvgPicture.asset(
                                  'images/images/driver/icon/verified_icon.svg',
                                  color: AppColors.primaryColor,
                                ),
                                percent: 4.9,
                              ),
                              const VerticalDivider(
                                  thickness: 1, color: Colors.black54),
                              RowText(
                                text: 'Rating',
                                image: SvgPicture.asset(
                                  'images/images/driver/icon/rating_icon.svg',
                                ),
                                percent: 4.9,
                              ),
                              const VerticalDivider(
                                  thickness: 1, color: Colors.black54),
                              RowText(
                                text: 'Cancellation',
                                image: SvgPicture.asset(
                                  'images/images/driver/icon/cancellation_icon.svg',
                                ),
                                percent: 5.0,
                              ),
                            ],
                          ),
                        ),
                        statusText != "Now Online"
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  // Implement onTap functionality
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      "Go Offline",
                                      style: TextStyle(color: Colors.black),
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
          ),
        ],
      ),
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
