
import 'package:dropsride/authentication/forgetPassword.dart';
import 'package:dropsride/global/pageNavigator.dart';
import 'package:flutter/material.dart';

import '../buttons/cuatom_buttons.dart';
import '../constant/gaps.dart';
import '../constant/sizes.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  ForgotPasswordBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:  EdgeInsets.symmetric(
            horizontal: AppSizes.padding * 2, vertical: AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hSizedBox4,
            Text(
              'Forgot Password?',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            hSizedBox2,
            Text(
              'Please select an option below to reset your password automatically.',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                letterSpacing: 1,
              ),
            ),
            Divider(
              height: AppSizes.p18 * 2.8,
              color: Theme.of(context).colorScheme.onBackground,
            ),

            // email button
            CustomButtons(
                ontap: () {
                  PageNavigator.navigateToNextPage(context, ForgetPassword());
                },
                icon: Icons.email_rounded,
                title: "Email",
                description: "Reset via email verification"),
            hSizedBox4,

            // otp button
            CustomButtons(
                ontap: () {
                  PageNavigator.navigateToNextPage(context, ForgetPassword());
                },
                icon: Icons.mobile_friendly_rounded,
                title: "Phone No",
                description: "Reset via phone verification"),
          ],
        ),
      ),
    );
  }
}
