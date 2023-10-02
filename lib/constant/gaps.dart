
import 'package:dropsride/constant/sizes.dart';
import 'package:flutter/material.dart';

import 'size.config.dart';

///Height Widgets
///SizeConfig.blockSizeVertical *
SizedBox hSizedBox0 = const SizedBox(
  height: 0,
);

SizedBox hSizedBox2 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p2,
);

SizedBox hSizedBox4 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p4,
);
SizedBox hSizedBox6 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p6,
);
SizedBox hSizedBox8 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p8,
);
SizedBox hSizedBox10 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p10,
);
SizedBox hSizedBox14 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p14,
);
SizedBox hSizedBox18 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p18,
);
SizedBox hSizedBox20 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p20,
);
SizedBox hSizedBox24 = SizedBox(
  height: SizeConfig.blockSizeVertical * AppSizes.p24,
);

/// Width Widgets
///  SizeConfig.blockSizeHorizontal *
SizedBox wSizedBox0 = const SizedBox(
  width: 0,
);
SizedBox wSizedBox2 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p2,
);
SizedBox wSizedBox4 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p4,
);
SizedBox wSizedBox6 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p6,
);
SizedBox wSizedBox8 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p8,
);
SizedBox wSizedBox10 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p10,
);
SizedBox wSizedBox14 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p14,
);
SizedBox wSizedBox18 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p18,
);
SizedBox wSizedBox20 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p20,
);
SizedBox wSizedBox24 = SizedBox(
  width: SizeConfig.blockSizeHorizontal * AppSizes.p24,
);

Widget addVerticalSpace(double height) => SizedBox(height: height);

Widget addHorizontalSpace(double width) => SizedBox(width: width);
