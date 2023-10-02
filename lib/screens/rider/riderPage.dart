import 'dart:async';

import 'package:dropsride/constant/colors.dart';
import 'package:dropsride/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../authentication/userInfoPage.dart';
import '../../constant/gaps.dart';
import '../../constant/size.config.dart';
import '../../constant/sizes.dart';
import '../../constants/assets.dart';
import '../../global/global.dart';
import '../../global/map_key.dart';
import '../../global/pageNavigator.dart';
import '../../infoHandler/app_info.dart';
import '../../models/active_nearby_available_drivers.dart';
import '../../models/assistant_method.dart';
import '../../models/directions.dart';
import '../../models/geofire_assistant.dart';
import '../../vehicle/car_info_screen.dart';
import '../precise_pickup_location.dart';
import '../select_destination_screen.dart';

import 'package:location/location.dart' as loc;

class RiderPage extends StatefulWidget {
  const RiderPage({Key? key}) : super(key: key);

  @override
  _RiderPageState createState() => _RiderPageState();
}

class _RiderPageState extends State<RiderPage> {
  bool rider = true;
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String statusText = "Now offline";
  bool isDriverActive = false;

  double searchLocationContainerHeight = 220;
  double waitingResponseFreeDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  double suggestedRidesContainerHeight = 0;
  double confirmPickUpContainerHeight = 0;

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

  String selectedVehicleType ="";

  @override
  void initState() {
    super.initState();

    locateUserPosition();

    checkIfLocationPermissionIsAllowed();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    createActiveNearByDriverIconMarker();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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

            // Your main content goes here

            // Positioned widget for the SVG icon
            Positioned(
              top: 50,
              left: 20,
              child: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: SvgPicture.asset(
                      'images/menu_icon.svg',
                      // Replace with your SVG asset path
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 1.0,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // locateYourPosition();
                            // locateUserPosition();
                            // print('object');
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 20),
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
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // Add your bottom sheet content here
                              // ...
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
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
                                              setState(() async {
                                                // openNavigationDrawer = false;
                                                // Call drawPolyLineFromOriginToDestination only if the response indicates "obtainedDropOff"
                                                await drawPolyLineFromOriginToDestination(
                                                    darkTheme);
                                              });
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              RoundedTextField(
                                                hintText: Provider.of<AppInfo>(
                                                                context)
                                                            .userPickUpLocation !=
                                                        null
                                                    ? (Provider.of<AppInfo>(
                                                                    context)
                                                                .userPickUpLocation!
                                                                .locationName !=
                                                            null
                                                        ? (Provider.of<AppInfo>(
                                                                        context)
                                                                    .userPickUpLocation!
                                                                    .locationName!
                                                                    .length >
                                                                24
                                                            ? "${Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0, 24)}..."
                                                            : Provider.of<
                                                                        AppInfo>(
                                                                    context)
                                                                .userPickUpLocation!
                                                                .locationName!)
                                                        : "Not Getting Address")
                                                    : "Not Getting Address",
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              RoundedTextField(
                                                hintText: Provider.of<AppInfo>(
                                                                context)
                                                            .userDropOffLocation !=
                                                        null
                                                    ? (Provider.of<AppInfo>(
                                                                    context)
                                                                .userDropOffLocation!
                                                                .locationName !=
                                                            null
                                                        ? (Provider.of<AppInfo>(
                                                                        context)
                                                                    .userDropOffLocation!
                                                                    .locationName!
                                                                    .length >
                                                                24
                                                            ? "${Provider.of<AppInfo>(context).userDropOffLocation!.locationName!.substring(0, 24)}..."
                                                            : Provider.of<
                                                                        AppInfo>(
                                                                    context)
                                                                .userDropOffLocation!
                                                                .locationName!)
                                                        : "Your Destination")
                                                    : "Your Destination",
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      PageNavigator
                                                          .navigateToNextPage(
                                                              context,
                                                              const PrecisePickUpScreen());
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: darkTheme
                                                                ? Colors.amber
                                                                    .shade400
                                                                : Colors.blue,
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Change pick up address",
                                                        style: TextStyle(
                                                          color: darkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (Provider.of<AppInfo>(
                                                                  context,
                                                                  listen: false)
                                                              .userDropOffLocation !=
                                                          null) {
                                                        showSuggestedRidesContainer();
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Please select destination location");
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: darkTheme
                                                                ? Colors.amber
                                                                    .shade400
                                                                : Colors.blue,
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Check fare",
                                                       style:   TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 16,
                                                          )),
                                                      ),
                                                    ),

                                                ],
                                              ),
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
                      ),
                    ),
                  ],
                );
              },
            ),

            //ui for sugested rides
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: suggestedRidesContainerHeight,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryColor.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    )
                  ],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                      AppSizes.padding * 2,
                    ),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SvgPicture.asset(
                                  Assets.assetsImagesIconsCurrentLocation,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(
                                  height: 37,
                                  child: VerticalDivider(
                                    width: AppSizes.p12,
                                    thickness: 2,
                                    indent: 8,
                                    endIndent: 8,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                                SvgPicture.asset(
                                  Assets.assetsImagesIconsLocationFilled,
                                ),
                              ],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Text(
                                      Provider.of<AppInfo>(context)
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
                                      softWrap: true,
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.3,
                                    height: AppSizes.padding * 2.4,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.6),
                                  ),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Text(
                                      Provider.of<AppInfo>(context)
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
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      hSizedBox4,
                      InkWell(
                        onTap: () {
                          //Get.to(() => const PaymentMethod());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(Assets.assetsImagesIconsCash),
                              wSizedBox4,
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Personal Trip",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                    ),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('card'),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.angleDown,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.7),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          selectedVehicleType = "Private";
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.padding * 1.4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.padding),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/images/privateRide.png",
                                  width: AppSizes.iconSize * 1.4,
                                ),
                                wSizedBox2,
                                Expanded(
                                  child: Text(
                                    "Private",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                                wSizedBox2,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      tripDirectionDetailsInfo != null
                                          ? "NGN ${((AssistanceMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2) * 950).toStringAsFixed(1)}"
                                          : "null",
                                      style: GoogleFonts.inter(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.secondaryColor,
                                            ),
                                      ),
                                    ),
                                    Text("${(2)} Km".toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()
                        {
                          selectedVehicleType = "Shared";
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(AppSizes.padding * 1.4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.padding),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/images/shareRide.png",
                                  width: AppSizes.iconSize * 1.4,
                                ),
                                wSizedBox2,
                                Expanded(
                                  child: Text(
                                    "Shared ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                wSizedBox2,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      tripDirectionDetailsInfo != null
                                          ? "NGN ${((AssistanceMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2) * 950).toStringAsFixed(1)}"
                                          : "null",
                                      style: GoogleFonts.inter(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                    ),
                                    Text("${(2)} Km".toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
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
                              updateIsDriver(false);
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
                                'Switch to Driver',
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
      ),
    );
  }

  showSuggestedRidesContainer() {
    setState(() {
      suggestedRidesContainerHeight = 400;
      bottomPaddingOfMap = 400;
    });
  }

  confirmPickupContainer() {
    setState(() {
      confirmPickUpContainerHeigh? = 400;
      bottomPaddingOfMap = 400;
    });
  }


  Future<void> createActiveNearByDriverIconMarker() async {
    if (activeNearbyIcon == null) {
      try {
        ImageConfiguration imageConfiguration =
            createLocalImageConfiguration(context, size: const Size(2, 2));
        activeNearbyIcon = await BitmapDescriptor.fromAssetImage(
            imageConfiguration, "images/images/driver/icon/car_top.png",);
      } catch (e) {
        print("Error loading icon: $e");
      }
    }
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

  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
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

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 15.4746,
  );

  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => ProgressDialog(
    //           message: "Please wait ...",
    //         ));
    var directionDetailsInfo =
        await AssistanceMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    // Navigator.pop(context);

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
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return TextFormField(
      style: const TextStyle(color: Colors.black),
      enabled: false,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.location_on,
          color: darkTheme ? AppColors.primaryColor : AppColors.secondaryColor,
        ),
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
