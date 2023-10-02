
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../../../common_widgets/appbar_title.dart';
import '../../../../constants/assets.dart';
import '../../../../constants/gaps.dart';
import '../../../../constants/size.dart';

class VehiclePaperScreen extends StatelessWidget {
  const VehiclePaperScreen({super.key});

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
            pageTitle: "Vehicle Paper",
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
                      'Provide scanned pictures of papers',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  hSizedBox4,
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Proof of Ownership/Change of Ownership',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  hSizedBox2,
                  // Padding(
                  //   padding: const EdgeInsets.all(AppSizes.padding),
                  //   child: InkWell(
                  //     onTap: () {
                  //       VehicleController.instance
                  //           .takeVehicleProofOfOwnershipPicture();
                  //     },
                  //     child: VehicleController
                  //                 .instance.vehicleProofOfOwnership.value !=
                  //             null
                  //         ? Image.file(VehicleController
                  //             .instance.vehicleProofOfOwnership.value!)
                  //         : Image.asset(
                  //             Assets.assetsImagesDriverCameraImagePlaceHolder),
                  //   ),
                  // ),
                  hSizedBox2,
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Certificate of Road Worthiness',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  hSizedBox2,
                  // Padding(
                  //   padding: const EdgeInsets.all(AppSizes.padding),
                  //   child: InkWell(
                  //     onTap: () {
                  //       VehicleController.instance
                  //           .takeVehicleRoadWorthinessPicture();
                  //     },
                  //     child: VehicleController
                  //                 .instance.vehicleRoadWorthiness.value !=
                  //             null
                  //         ? Image.file(VehicleController
                  //             .instance.vehicleRoadWorthiness.value!)
                  //         : Image.asset(
                  //             Assets.assetsImagesDriverCameraImagePlaceHolder),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Vehicle License or Registration',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  hSizedBox2,
                  // Padding(
                  //   padding: const EdgeInsets.all(AppSizes.padding),
                  //   child: InkWell(
                  //     onTap: () {
                  //       VehicleController.instance
                  //           .takeVehicleRegistrationPicture();
                  //     },
                  //     child: VehicleController
                  //                 .instance.vehicleRegistration.value !=
                  //             null
                  //         ? Image.file(VehicleController
                  //             .instance.vehicleRegistration.value!)
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
