import 'package:flutter/material.dart';

import '../constant/gaps.dart';
import '../constant/sizes.dart';

class CustomButtons extends StatelessWidget {
  CustomButtons({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.ontap,
  });

  IconData icon;
  String title;
  String description;
  void Function() ontap;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.padding),
            color: Theme.of(context).colorScheme.onSurface),
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: AppSizes.iconSize * 3),
            wSizedBox4,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
