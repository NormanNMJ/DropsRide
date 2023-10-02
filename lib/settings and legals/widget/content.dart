
import 'package:flutter/material.dart';

import '../../../constants/gaps.dart';

class PrivacyTextDetail extends StatelessWidget {
  PrivacyTextDetail({
    super.key,
    required this.titleText,
    required this.numberText,
    required this.contentText,
  });

  String titleText;
  String numberText;
  String contentText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(numberText),
        wSizedBox4,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onBackground),
                softWrap: true,
              ),
              hSizedBox2,
              Text(
                contentText,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onBackground),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              hSizedBox6,
            ],
          ),
        )
      ],
    );
  }
}
