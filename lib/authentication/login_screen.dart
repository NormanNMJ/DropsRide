import 'package:dropsride/authentication/forgetPassword.dart';
import 'package:dropsride/authentication/signUp_screen.dart';
import 'package:dropsride/screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constant/colors.dart';
import '../../constant/gaps.dart';
import '../../constant/sizes.dart';
import '../../global/global.dart';
import '../../global/pageNavigator.dart';
import '../../constant/size.config.dart';
import 'forgotPasswordBottomSheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  bool passwordVisible = false;
  final _formKeyRider = GlobalKey<FormState>();
  bool isDriver = true;
  bool _isLoading = false;

  void _submitRiderLogin() async {
    if (_formKeyRider.currentState!.validate()) {
      print('object');
      setState(() {
        _isLoading = true;
      });
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );
      // For demonstration, we'll just show a toast
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      setState(() {
        _isLoading = false;
      });
      _goToHomeScreen();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not all fields are valid')),
      );
    }
  }


  _goToForgotPasswordScreen() {
    PageNavigator.navigateToNextPage(context, const ForgetPassword());
  }

  _goToSignUpScreen() {
    PageNavigator.navigateToNextPage(context, SignUpScreen());
  }

  _goToHomeScreen() {
    PageNavigator.navigateToNextPage(context, const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: true,

                // Set the app bar background color to transparent
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Navigate back to the previous page
                  },
                ),
                actions: const [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'Login as rider',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: Form(
                      key: _formKeyRider,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          hSizedBox2,
                          Text(
                            'Login with your details',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
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
                            hintText: 'Email',
                            controller: emailTextEditingController,
                            icon: Icons.person_2_outlined,
                          ),
                          hSizedBox4,
                          RoundedTextField(
                            hintText: 'Password',
                            controller: passwordTextEditingController,
                            icon: Icons.lock_outline,
                          ),
                        
                          hSizedBox4,
                          Center(
                            child: TextButton(
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.padding),
                                  ),
                                  builder: (context) {
                                    return ForgotPasswordBottomSheet();
                                  },
                                ),
                                child: Text(
                                  'Forgot Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),

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
                        // Add a 2-second delay before calling _submitDriverLogin()
                        Future.delayed(Duration(seconds: 1), () {
                          _submitRiderLogin();
                        });
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
                                        fontSize:
                                            SizeConfig.screenHeight * 0.026,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                )
                              ],
                            )
                          : Text(
                              "Login",
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
                ],
              ),
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
