import 'package:dropsride/authentication/signUp_screen.dart';
import 'package:dropsride/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constant/colors.dart';
import '../constant/gaps.dart';
import '../constant/sizes.dart';
import '../constants/assets.dart';
import '../global/pageNavigator.dart';
import '../constant/size.config.dart';
import 'login_screen.dart';

final emailTextEditingController = TextEditingController();

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    bool _isLoading = false;

    _goToLoginScreen() {
      ReplacePageNavigator.navigateToNextPage(context, LoginScreen());
    }

    void _submitPasswordRecovery() async {
      if (emailTextEditingController.text != "") {
        await firebaseAuth.sendPasswordResetEmail(
            email: emailTextEditingController.text.trim());
        // For demonstration, we'll just show a toast
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recovery email sent!')),
        );
        _goToLoginScreen();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not all fields are valid')),
        );
      }
    }

    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.padding * 2,
            AppSizes.padding * 4,
            AppSizes.padding * 2,
            AppSizes.padding,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.assetsImagesSvgForgotPasswordSvg,
                  width: SizeConfig.screenWidth * (1 / 1.5),
                ),
                wSizedBox4,
                // form heading
                Text(
                  'Email Reset',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                hSizedBox6,
                Text(
                  textAlign: TextAlign.center,
                  'Please enter your email address below to be emailed the password reset link.',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),

                Divider(
                  height: AppSizes.p18 * 4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),

                // input for the email and phone
                SizedBox(
                  width: double.maxFinite,
                  child: RoundedTextField(
                    hintText: 'Email',
                    controller: emailTextEditingController,
                    icon: Icons.person_2_outlined,
                  ),
                ),

                // Submit the verification email or otp
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
                      // Add a 2-second delay before calling _submitDriverLogin()
                      Future.delayed(Duration(seconds: 1), () {
                        _submitPasswordRecovery();
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
                            "Verify",
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
                hSizedBox2,

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                )
              ],
            ),
          ),
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
