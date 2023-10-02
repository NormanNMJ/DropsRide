import 'package:dropsride/global/pageNavigator.dart';
import 'package:dropsride/screens/home_screen.dart';
import 'package:dropsride/splashScreen/splash_screen.dart';
import 'package:dropsride/splashScreen/startup_Screen.dart';
import 'package:dropsride/vehicle/vehicle_papers.dart';
import 'package:dropsride/vehicle/vehicle_photos.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common_widgets/appbar_title.dart';
import '../constant/colors.dart';
import '../constant/gaps.dart';
import '../constant/sizes.dart';
import '../global/global.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  final carModelEditingController = TextEditingController();
  final carColorEditingController = TextEditingController();
  final plateNumberEditingController = TextEditingController();

  List<String> carTypes = ["Private", "Shared"];
  String? selectedCarType;
  bool _isLoading = false; // Variable to track loading state


  _goToStartUpScreen() {
    PageNavigator.navigateToNextPage(context,  StartUpScreen());
  }


  final _formKey = GlobalKey<FormState>();

  _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map driverCarInfoMap = {
        "car_model": carModelEditingController.text.trim(),
        "car_color": carColorEditingController.text.trim(),
        "car_type": selectedCarType,
        "car_number": plateNumberEditingController.text.trim(),
        "car_photos": "",
        "car_papers": "",
      };

      DatabaseReference userRef =
      FirebaseDatabase.instance.ref().child("drivers");
      userRef.child(currentUser!.uid).child("car_details")
      .set(driverCarInfoMap);

      await Fluttertoast.showToast(msg: 'Car details saved');
      setState(() {
        _isLoading = false;
      });
      _goToStartUpScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () =>
                ReplacePageNavigator.navigateToNextPage(context, HomeScreen()),
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          titleSpacing: AppSizes.padding,
          primary: true,
          scrolledUnderElevation: AppSizes.p4,
          title: const AppBarTitle(
            pageTitle: "Vehicle",
          ),
        ),
        body: Form(
          key: _formKey,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.padding * 1.4),
              child: Form(
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        PageNavigator.navigateToNextPage(
                            context, const VehiclePhotoScreen());
                        // Get.to(() => const VehiclePhotoScreen());
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                        backgroundColor: MaterialStateProperty.all(darkTheme
                            ? AppColors.backgroundColorDark
                            : AppColors.backgroundColorLight),
                        elevation: MaterialStateProperty.all(4),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 14,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vehicle Photos',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const Icon(FontAwesomeIcons.angleRight)
                        ],
                      ),
                    ),
                    hSizedBox2,
                    TextFormField(
                      controller: carModelEditingController,
                      onTapOutside: (event) {},
                      onChanged: (value) {},
                      onSaved: (newValue) {},
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                      enableSuggestions: true,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableIMEPersonalizedLearning: true,
                      decoration: InputDecoration(
                        label: const Text('Model'),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onSecondary,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.margin,
                          ),
                          borderSide: const BorderSide(
                              width: AppSizes.p2,
                              color: AppColors.primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.margin,
                          ),
                          borderSide: const BorderSide(
                              width: AppSizes.p2, color: AppColors.red),
                        ),
                      ),
                    ),
                    hSizedBox2,
                    TextFormField(
                      controller: carColorEditingController,
                      onTapOutside: (event) {},
                      onChanged: (value) {},
                      onSaved: (newValue) {},
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                      enableSuggestions: true,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableIMEPersonalizedLearning: true,
                      decoration: InputDecoration(
                        label: const Text('Color'),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onSecondary,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.margin,
                          ),
                          borderSide: const BorderSide(
                              width: AppSizes.p2,
                              color: AppColors.primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.margin,
                          ),
                          borderSide: const BorderSide(
                              width: AppSizes.p2, color: AppColors.red),
                        ),
                      ),
                    ),
                    hSizedBox2,
                    DropdownButtonFormField<String>(
                      value: selectedCarType,
                      onChanged: (value) {
                        setState(() {
                          selectedCarType = value;
                        });
                      },
                      items: carTypes.map((carType) {
                        return DropdownMenuItem<String>(
                          value: carType,
                          child: Text(carType),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        label: const Text('Car Type'),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        filled: false,
                        fillColor: Theme.of(context).colorScheme.onSecondary,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.margin),
                          borderSide: const BorderSide(
                              width: AppSizes.p2,
                              color: AppColors.primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.margin),
                          borderSide: const BorderSide(
                              width: AppSizes.p2, color: AppColors.red),
                        ),
                      ),
                    ),
                    hSizedBox2,
                    TextFormField(
                      controller: plateNumberEditingController,
                      onTapOutside: (event) {},
                      onChanged: (value) {},
                      onSaved: (newValue) {},
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                      enableSuggestions: true,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableIMEPersonalizedLearning: true,
                      decoration: InputDecoration(
                        label: const Text('Plate Number'),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onSecondary,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.margin,
                          ),
                          borderSide: const BorderSide(
                              width: AppSizes.p2,
                              color: AppColors.primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.margin,
                          ),
                          borderSide: const BorderSide(
                              width: AppSizes.p2, color: AppColors.red),
                        ),
                      ),
                    ),
                    hSizedBox2,
                    OutlinedButton(
                      onPressed: () {
                        PageNavigator.navigateToNextPage(
                            context, const VehiclePaperScreen());

                        // Get.to(() => const VehiclePaperScreen());
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                        backgroundColor: MaterialStateProperty.all(darkTheme
                            ? AppColors.backgroundColorDark
                            : AppColors.backgroundColorLight),
                        elevation: MaterialStateProperty.all(4),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 14,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vehicle Papers',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const Icon(FontAwesomeIcons.angleRight)
                        ],
                      ),
                    ),
                    hSizedBox2,
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () async {
                          _submit();
                          // final imageUrls = await VehicleController.instance
                          //     .updateVehiclePapers();
                          // VehicleController.instance.saveVehiclePapers(imageUrls);
                        },
                        child: Text(
                          'Submit Details',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
