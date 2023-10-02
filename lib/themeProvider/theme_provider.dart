import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';
import '../constant/sizes.dart';


class MyThemes {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.secondaryColor,
    textTheme: GoogleFonts.urbanistTextTheme(
      ThemeData
          .dark()
          .textTheme,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.secondaryColor,
      modalBackgroundColor: AppColors.secondaryColor,
      modalBarrierColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.padding * 2),
          topRight: Radius.circular(AppSizes.padding * 2),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.white300,
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primaryColor,
    ).copyWith(background: AppColors.secondaryColor),

    // general input decoration theme style
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey400,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p16),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: AppSizes.p2,
        ),
      ),
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p16),
        borderSide: const BorderSide(
          color: AppColors.grey300,
          width: AppSizes.p2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.margin,
        ),
        borderSide: const BorderSide(width: AppSizes.p2, color: AppColors.red),
      ),
      focusColor: AppColors.white300,
    ),

    // elevated button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: AppColors.primaryColor,
        fixedSize: const Size.fromWidth(double.infinity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.p12),
        ),
        elevation: AppSizes.p8,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.buttonHeight / 2.7,
        ),
      ),
    ),


  );

  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.whiteColor,
    textTheme: GoogleFonts.urbanistTextTheme(
      ThemeData
          .light()
          .textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.secondaryColor,
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.secondaryColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primaryColor,
    ).copyWith(background: AppColors.white300),

    // general input decoration style
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      fillColor: AppColors.white300,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p12),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: AppSizes.p2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p12),
        borderSide: const BorderSide(
          color: AppColors.grey200,
          width: AppSizes.p2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.margin,
        ),
        borderSide: const BorderSide(width: AppSizes.p2, color: AppColors.red),
      ),
      focusColor: AppColors.grey200,
    ),

    // elevated button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: AppColors.primaryColor,
        fixedSize: const Size.fromWidth(double.infinity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.p12),
        ),
        elevation: AppSizes.p8,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.buttonHeight / 2.7,
        ),
      ),
    ),

    // outlines button
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //   style: OutlinedButton.styleFrom(
    //     foregroundColor: AppColors.primaryColor,
    //     backgroundColor: AppColors.white300,
    //     fixedSize: const Size.fromWidth(double.infinity),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(AppSizes.p12),
    //     ),
    //     elevation: AppSizes.p8,
    //     padding: const EdgeInsets.symmetric(
    //       vertical: AppSizes.buttonHeight / 2.7,
    //     ),
    //   ),
    // ),
  );
}