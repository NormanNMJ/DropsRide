
import 'package:flutter/material.dart';

import '../constant/colors.dart';

class CustomCheckBoxTile extends StatelessWidget {
  CustomCheckBoxTile({
    super.key,
    required this.controller,
    required this.text,
  });

  String text;
  dynamic controller;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      checkColor: AppColors.secondaryColor,
      activeColor: AppColors.primaryColor,
      selectedTileColor: Colors.transparent,
      tileColor: Colors.transparent,
      dense: true,
      tristate: false,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      value: controller.check.value,
      title: Text(
        text,
        softWrap: false,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      onChanged: (value) => controller.check.value = value!,
    );
  }
}
