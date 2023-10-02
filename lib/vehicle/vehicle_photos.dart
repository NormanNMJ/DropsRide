import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common_widgets/appbar_title.dart';
import '../constant/gaps.dart';
import '../constant/sizes.dart';
import '../constants/assets.dart';


class VehiclePhotoScreen extends StatelessWidget {
  const VehiclePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          titleSpacing: AppSizes.padding,
          primary: true,
          scrolledUnderElevation: AppSizes.p4,
          title: const AppBarTitle(
            pageTitle: "Vehicle Photos",
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding * 1.4),
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Provide pictures of your vehicle',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  hSizedBox4,
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Front',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  hSizedBox2,
                  // InkWell(
                  //   onTap: () {
                  //     VehicleController.instance.takeVehicleFrontPicture();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(AppSizes.padding),
                  //     child: VehicleController.instance.vehicleFront.value !=
                  //             null
                  //         ? Image.file(
                  //             VehicleController.instance.vehicleFront.value!)
                  //         : Image.asset(
                  //             Assets.assetsImagesDriverCameraImagePlaceHolder),
                  //   ),
                  // ),
                  hSizedBox2,
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Back',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  hSizedBox2,
                  // InkWell(
                  //   onTap: () {
                  //     VehicleController.instance.takeVehicleBackPicture();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(AppSizes.padding),
                  //     child: VehicleController.instance.vehicleBack.value !=
                  //             null
                  //         ? Image.file(
                  //             VehicleController.instance.vehicleBack.value!)
                  //         : Image.asset(
                  //             Assets.assetsImagesDriverCameraImagePlaceHolder),
                  //   ),
                  // ),
                  hSizedBox4,
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Continue',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
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
        ));
  }
}
