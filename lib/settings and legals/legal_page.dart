
import 'package:dropsride/global/pageNavigator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common_widgets/appbar_title.dart';
import '../../../constants/gaps.dart';
import '../../../constants/size.dart';
import 'contact_screen.dart';
import 'widget/content.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: AppSizes.padding * 2,
        title: const AppBarTitle(
          pageTitle: 'Privacy Policy',
        ),
        actions: [
          InkWell(
              onTap: () async {
                PageNavigator.navigateToNextPage(context, ContactScreen());
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    vertical: AppSizes.padding,
                    horizontal: AppSizes.padding * 2),
                child: Icon(Icons.support_agent),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.padding * 2),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Privacy Policy outlines the types of data collected, the use of personal data, and the disclosure of personal data when you use our ride-hailing application (referred to as the "Application"). This policy applies to all users of the Application.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              hSizedBox6,
              PrivacyTextDetail(
                numberText: '1',
                titleText: 'Type of Data we Collect',
                contentText:
                    '1.1 Personal Information:\n\nWe may collect the following personal information from you when you use the Application:\n\n- Name\n\n- Contact information (such as phone number and email address)\n\n- Payment information (such as credit card details)\n\n- Profile information (including profile picture)\n\n- Location data (such as pickup and drop-off locations)\n\n- Ratings and reviews\n\n\n\n1.2 Non-Personal Information:\n\nWe may also collect non-personal information, which does not directly identify you. This includes:\n\n- Device information (such as device type and operating system)\n\n- Log data (including IP address, browser type, and pages visited)\n\n- Usage data (such as interaction with the Application, preferences, and settings)',
              ),
              PrivacyTextDetail(
                numberText: '2',
                titleText: 'Use of Your Personal Data',
                contentText:
                    'We use the collected personal data for the following purposes:\n\n- Providing ride-hailing services, including matching you with drivers, facilitating communication between you and drivers, and processing payments.\n\n- Verifying your identity and ensuring the security of your account.\n\n- Improving and optimizing our services, including enhancing the functionality and user experience of the Application.\n\n- Sending you important updates, notifications, and promotional offers related to the Application.\n\n- Analyzing usage patterns and trends to understand user preferences and behavior.\n\n- Resolving disputes, addressing technical issues, and enforcing our terms and conditions',
              ),
              PrivacyTextDetail(
                numberText: '3',
                titleText: 'Disclosure of Your Personal Data',
                contentText:
                    'We may disclose your personal data in the following circumstances:\n\n- To drivers or service providers involved in providing the ride-hailing services you request\n\n- With your consent or at your direction, such as when you choose to share your ride details with others\n\n- To comply with legal obligations, enforce our rights, or protect the safety and security of our users and the public\n\n- In connection with a merger, acquisition, or sale of our business assets, where personal data may be transferred as part of the transaction\n\n- To authorized third-party service providers who assist us in operating and managing the Application, subject to their adherence to appropriate privacy and security measures',
              ),
              PrivacyTextDetail(
                numberText: '4',
                titleText: 'Data Retention',
                contentText:
                    'We retain your personal data for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
              ),
              PrivacyTextDetail(
                numberText: '5',
                titleText: 'Data Security',
                contentText:
                    'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction. However, no data transmission or storage system can be guaranteed to be 100% secure. You understand and acknowledge this inherent risk and agree to use the Application at your own discretion.',
              ),
              PrivacyTextDetail(
                numberText: '6',
                titleText: 'Children Privacy',
                contentText:
                    'The Application is not intended for use by individuals under the age of 18. We do not knowingly collect personal data from children. If you believe that we have unintentionally collected personal data from a child, please contact us immediately, and we will take steps to delete the information.',
              ),
              PrivacyTextDetail(
                numberText: '7',
                titleText: 'Changes to Privacy Policy',
                contentText:
                    'We reserve the right to update or modify this Privacy Policy at any time. We will notify you of any material changes by posting the updated Privacy Policy in the Application or through other means of communication. Your continued use of the Application after the changes will signify your acceptance of the revised Privacy Policy.',
              ),
              Text(
                'If you have any questions, concerns, or requests regarding this Privacy Policy or the handling of your personal data, please contact us at support@dropsride.com.\n\nBy using the Application, you acknowledge that you have read and understood this Privacy Policy and consent to the collection, use, and disclosure of your personal data as described herein.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
