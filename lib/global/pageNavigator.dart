import 'package:flutter/material.dart';

import '../animation/progressDialog.dart';

class PageNavigator {
  static navigateToNextPage(BuildContext context, Widget destinationPage) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500), // Custom duration for the animation

        pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Change to start from right
          const end = Offset.zero;

          var curve = Curves.easeInBack; // Custom curve for a smoother and slower animation

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          // Fade effect with a more noticeable fade
          var fadeTween = Tween(begin: 0.0, end: 0.5);

          return Stack(
            children: [
              FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
              SlideTransition(
                position: animation.drive(tween),
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}



class ReplacePageNavigator {
  static void navigateToNextPage(BuildContext context, Widget destinationPage) {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show();

    Future.delayed(Duration(seconds: 1), () {
      progressDialog.hide();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => destinationPage),
      );
    });
  }
}