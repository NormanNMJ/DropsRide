// AnimatedPositioned(
//                   curve: Curves.decelerate,
//                   duration: const Duration(milliseconds: 400),
//                   top: DestinationController.instance.isExpanded.value
//                       ? SizeConfig.screenHeight
//                       : SizeConfig.screenHeight * 0.45,
//                   child: GestureDetector(
//                     onPanEnd: (details) {
//                       if (details.velocity.pixelsPerSecond.dy > 80) {
//                         DestinationController.instance.isExpanded.value = false;
//                       } else if (details.velocity.pixelsPerSecond.dy == 0.0) {
//                         DestinationController.instance.isExpanded.value = true;
//                       } else {
//                         DestinationController.instance.isExpanded.value = true;
//                       }
//                     },
//                     child: Container(
//                       height: SizeConfig.screenHeight,
//                       width: SizeConfig.screenWidth,
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.background,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(AppSizes.padding * 2),
//                             topRight: Radius.circular(AppSizes.padding * 2),
//                           ),
//                           boxShadow: const [
//                             BoxShadow(color: Colors.transparent)
//                           ]),
//                       padding: const EdgeInsets.all(
//                         AppSizes.padding,
//                       ),
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: AppSizes.padding,
//                               horizontal: AppSizes.padding * 2),
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: 2,
//                                 width: SizeConfig.screenWidth * 0.2,
//                                 child: Divider(
//                                     thickness: 3,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onBackground
//                                         .withOpacity(0.5)),
//                               ),
//                               hSizedBox2,
//                               Column(
//                                   children: [
//                                     Text(
//                                       'Address Details',
//                                       textAlign: TextAlign.center,
//                                       style: Theme.of(Get.context!)
//                                           .textTheme
//                                           .labelMedium!
//                                           .copyWith(
//                                             fontWeight: FontWeight.w900,
//                                             fontSize: 20,
//                                             color: Theme.of(Get.context!)
//                                                 .colorScheme
//                                                 .onBackground,
//                                           ),
//                                     ),
//                                     Divider(
//                                       height: AppSizes.padding * 3,
//                                       thickness: 1.4,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                     ),
                                    
//                                       Form(
//                                         child: Column(
//                                           children: [
//                                             TextFormField(
//                                               enableIMEPersonalizedLearning:
//                                                   true,
//                                               onTapOutside: (event) =>
//                                                   FocusScope.of(context)
//                                                       .unfocus(),
//                                               decoration: InputDecoration(
//                                                 label: const Text('Name'),
//                                                 floatingLabelBehavior:
//                                                     FloatingLabelBehavior.auto,
//                                                 floatingLabelAlignment:
//                                                     FloatingLabelAlignment
//                                                         .start,
//                                                 filled: true,
//                                                 fillColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .onSecondary,
//                                                 isDense: true,
//                                                 focusedBorder:
//                                                     OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     AppSizes.margin,
//                                                   ),
//                                                   borderSide: const BorderSide(
//                                                       width: AppSizes.p2,
//                                                       color: AppColors
//                                                           .primaryColor),
//                                                 ),
//                                                 errorBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     AppSizes.margin,
//                                                   ),
//                                                   borderSide: const BorderSide(
//                                                       width: AppSizes.p2,
//                                                       color: AppColors.red),
//                                                 ),
//                                               ),
//                                             ),
//                                             hSizedBox2,
//                                             TextFormField(
//                                               initialValue:
//                                                   DestinationController.instance
//                                                       .currentAddress.value,
//                                               onTap: () {
//                                                 DestinationController.instance
//                                                     .searchPlaces();
//                                               },
//                                               onTapOutside: (event) =>
//                                                   FocusScope.of(context)
//                                                       .unfocus(),
//                                               enableIMEPersonalizedLearning:
//                                                   true,
//                                               decoration: InputDecoration(
//                                                 suffixIcon: const Icon(
//                                                     FontAwesomeIcons.location),
//                                                 label: const Text('Address'),
//                                                 floatingLabelBehavior:
//                                                     FloatingLabelBehavior.auto,
//                                                 floatingLabelAlignment:
//                                                     FloatingLabelAlignment
//                                                         .start,
//                                                 filled: true,
//                                                 fillColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .onSecondary,
//                                                 isDense: true,
//                                                 focusedBorder:
//                                                     OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     AppSizes.margin,
//                                                   ),
//                                                   borderSide: const BorderSide(
//                                                       width: AppSizes.p2,
//                                                       color: AppColors
//                                                           .primaryColor),
//                                                 ),
//                                                 errorBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     AppSizes.margin,
//                                                   ),
//                                                   borderSide: const BorderSide(
//                                                       width: AppSizes.p2,
//                                                       color: AppColors.red),
//                                                 ),
//                                               ),
//                                             ),
//                                             hSizedBox2,
//                                             SizedBox(
//                                               width: double.maxFinite,
//                                               child: ElevatedButton(
//                                                 onPressed: () {},
//                                                 child: Text('Add New Address',
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .displayMedium!
//                                                         .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w900,
//                                                           fontSize: 17,
//                                                         )),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
                                    
//                                   ],
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );