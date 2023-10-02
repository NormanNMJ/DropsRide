import 'package:dropsride/global/pageNavigator.dart';
import 'package:dropsride/vehicle/car_info_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../constant/colors.dart';
import '../constant/gaps.dart';
import '../constant/size.config.dart';

import '../constant/sizes.dart';
import '../constants/assets.dart';
import '../global/global.dart';
import '../screens/home_screen.dart';

import 'package:flutter/material.dart';

import '../settings and legals/legal_page.dart';
import 'login_screen.dart';

bool isDriver = false;

final nameTextEditingController = TextEditingController();
final emailTextEditingController = TextEditingController();
final passwordTextEditingController = TextEditingController();
final confirmPasswordTextEditingController = TextEditingController();

bool passwordVisible = false;
bool _isLoading = false; // Variable to track loading state

bool _value = false;

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


//declare Gl
// obalKey
  final _formKeySignUpRider = GlobalKey<FormState>();
  _goToHomeScreen() {
    PageNavigator.navigateToNextPage(context, const HomeScreen());
  }

  void _submitUserDetails() async {
    //validate all forms
    if (_formKeySignUpRider.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;

        if (currentUser != null) {
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "isDriver": isDriver,
          };
          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: 'Successfully Registered');
        setState(() {
          _isLoading = false;
        });
        _goToHomeScreen();
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: 'Error occurred: \n $errorMessage');
      });
    } else {
      Fluttertoast.showToast(msg: "Not all field are valid");
    }
  }

//
  @override
  Widget build(BuildContext context) {
    _goToLoginScreen() {
      PageNavigator.navigateToNextPage(context, const LoginScreen());
    }

    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    List<bool> isSelected = [true, false]; // Initialize with Rider selected

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Form(
              key: _formKeySignUpRider,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  hSizedBox2,
                  Text(
                    'Please enter your details',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.3,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                  ),
                  Divider(
                    height: AppSizes.p18 * 4,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  RoundedTextField(
                    hintText: 'Name',
                    controller: nameTextEditingController,
                    icon: Icons.person_2_outlined,
                  ),
                  hSizedBox4,
                  RoundedTextField(
                    hintText: 'Email',
                    controller: emailTextEditingController,
                    icon: Icons.email_outlined,
                  ),
                  hSizedBox4,
                  RoundedTextField(
                    hintText: 'Password',
                    controller: passwordTextEditingController,
                    icon: Icons.lock_outline,
                  ),
                  hSizedBox6,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text("Rider".toUpperCase(),
    style:
    Theme.of(context).textTheme.titleMedium!.copyWith(
    color: darkTheme
    ? AppColors.primaryColor
        : AppColors.secondaryColor,
    ),),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    child: Switch(
                      value: isDriver,
                      onChanged: (isOn) {
                        setState(() {
                          isDriver = isOn;
                        });

                      },
                    ),
                  ),
                ),
                Text("Driver".toUpperCase(),
                  style:
                  Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: darkTheme
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor,
                  ),),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        activeColor: Colors.amber,
                        checkColor: Colors.grey,
                        value: _value,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _value = newValue!;
                          });
                        }),
                    GestureDetector(
                      onTap: () {
                        PageNavigator.navigateToNextPage(context, LegalPage());
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'I agree to ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'terms',
                              style: TextStyle(color: Colors.amber),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'privacy',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                hSizedBox4,

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.infinity),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.p12),
                      ),
                      elevation: AppSizes.p8,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.buttonHeight / 2.9,
                      ),
                    ),
                    onPressed: () {
                      _submitUserDetails();
                    },
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator.adaptive(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              wSizedBox6,
                              Text(
                                'Loading...',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      fontSize: SizeConfig.screenHeight * 0.026,
                                      fontWeight: FontWeight.w900,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              )
                            ],
                          )
                        : Text(
                            "SignUp",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontSize: SizeConfig.screenHeight * 0.026,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                  ),
                ),
                wSizedBox6,
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          _goToLoginScreen();
                        },
                        child: const Text('Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                hSizedBox4,
                Divider(
                  height: AppSizes.p18 * 4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.infinity),
                      backgroundColor: Colors.transparent,
                      foregroundColor: darkTheme
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                      side: BorderSide(
                        width: 2,
                        color: darkTheme
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.p12),
                      ),
                      elevation: darkTheme ? AppSizes.p8 : 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.buttonHeight / 2.9,
                      ),
                    ),
                    onPressed: () {
                      // aController.signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.assetsImagesIconsGoogle,
                          width: SizeConfig.screenWidth * (1 / 12.5),
                        ),
                        wSizedBox4,
                        Text(
                          "Login with Google".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: darkTheme
                                        ? AppColors.primaryColor
                                        : AppColors.secondaryColor,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
                hSizedBox2,
                SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.infinity),
                      backgroundColor: Colors.transparent,
                      foregroundColor: darkTheme
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                      side: BorderSide(
                        width: 2,
                        color: darkTheme
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.p12),
                      ),
                      elevation: darkTheme ? AppSizes.p8 : 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.buttonHeight / 2.9,
                      ),
                    ),
                    onPressed: () {
                      // aController.signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.assetsImagesIconsFacebook,
                          width: SizeConfig.screenWidth * (1 / 12.5),
                        ),
                        wSizedBox4,
                        Text(
                          "Login with Facebook".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: darkTheme
                                        ? AppColors.primaryColor
                                        : AppColors.secondaryColor,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
                hSizedBox2,
                SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.infinity),
                      backgroundColor: Colors.transparent,
                      foregroundColor: darkTheme
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                      side: BorderSide(
                        width: 2,
                        color: darkTheme
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.p12),
                      ),
                      elevation: darkTheme ? AppSizes.p8 : 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.buttonHeight / 2.9,
                      ),
                    ),
                    onPressed: () {
                      // aController.signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.assetsImagesIconsApple,
                          width: SizeConfig.screenWidth * (1 / 12.5),
                        ),
                        wSizedBox4,
                        Text(
                          "Login with Apple".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: darkTheme
                                        ? AppColors.primaryColor
                                        : AppColors.secondaryColor,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;

  final String? hintText;

  const RoundedTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return TextFormField(
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
          color: Theme.of(context).colorScheme.onSecondaryContainer),
      enableSuggestions: true,
      enableIMEPersonalizedLearning: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      controller: controller,
      decoration: InputDecoration(
        // labelText: "Email",
        prefixIcon: Icon(
          icon,
          size: AppSizes.iconSize,
        ),
        label: Text(hintText!),
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
              width: AppSizes.p2, color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.margin,
          ),
          borderSide:
              const BorderSide(width: AppSizes.p2, color: AppColors.red),
        ),
      ),
      validator: (value) {
        // Add your validation logic here
        return null; // Return null if validation passes
      },
    );
  }
}
