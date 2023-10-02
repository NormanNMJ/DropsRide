
import 'package:flutter/material.dart';

import '../constant/sizes.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.pageTitle,
  });

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      pageTitle,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontSize: AppSizes.p22,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
