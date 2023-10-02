
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/gaps.dart';
import '../../../constants/size.dart';

class ContactButton extends StatelessWidget {
  ContactButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.fa,
  });

  String title;
  bool fa;
  IconData icon;

  Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonHeight / 2,
            vertical: AppSizes.margin * 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            fa
                ? FaIcon(
                    icon,
                    size: AppSizes.iconSize * 1.6,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  )
                : Icon(
                    icon,
                    size: AppSizes.iconSize * 1.6,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
            wSizedBox4,
            Text(
              title,
              softWrap: true,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    fontWeight: FontWeight.w900,
                    fontSize: AppSizes.iconSize,
                  ),
            )
          ],
        ));
  }
}
