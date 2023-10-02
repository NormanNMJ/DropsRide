import 'package:flutter/material.dart';

class ProgressDialog {
  final BuildContext context;
  late AlertDialog alertDialog;

  ProgressDialog({required this.context}) {
    alertDialog = AlertDialog(
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }


  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void hide() {
    Navigator.pop(context);
  }
}
