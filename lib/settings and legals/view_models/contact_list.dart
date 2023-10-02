
import 'package:dropsride/global/pageNavigator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/gaps.dart';
import '../../../constants/size.dart';
import '../live_support.dart';
import '../widget/contact_buttons.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.padding * 2),
      children: [
        ContactButton(
          fa: false,
          title: 'Customer Service',
          icon: Icons.support_agent_rounded,
          onPressed: () async {
            PageNavigator.navigateToNextPage(context, CustomerSupport());
          },
        ),
        hSizedBox4,
        ContactButton(
          fa: true,
          title: 'Direct Line',
          icon: FontAwesomeIcons.phone,
          onPressed: () async {
            final url = Uri(scheme: 'tel', path: '+2347064857582');
            // const url = 'https://dropsride.com';
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalNonBrowserApplication,
              );
            }
          },
        ),
        hSizedBox4,
        ContactButton(
          fa: true,
          title: 'Whatsapp',
          icon: FontAwesomeIcons.whatsapp,
          onPressed: () async {
            final url = Uri(scheme: 'https', path: 'wa.me/+2347064857582');
            // const url = 'https://dropsride.com';
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalNonBrowserApplication,
                webOnlyWindowName: "Dropsride Whatsapp",
              );
            }
          },
        ),
        hSizedBox4,
        ContactButton(
          fa: true,
          title: 'Website',
          icon: FontAwesomeIcons.globe,
          onPressed: () async {
            final url = Uri(scheme: 'https', path: 'dropsride.com');
            // const url = 'https://dropsride.com';
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                webViewConfiguration: const WebViewConfiguration(
                    enableJavaScript: true, enableDomStorage: true),
                mode: LaunchMode.externalApplication,
                webOnlyWindowName: "Dropsride",
              );
            }
          },
        ),
        hSizedBox4,
        ContactButton(
          fa: false,
          title: 'Facebook',
          icon: Icons.facebook,
          onPressed: () async {
            final url = Uri(scheme: 'https', path: 'facebook.com/dropsride');
            // const url = 'https://dropsride.com';
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalNonBrowserApplication,
                webOnlyWindowName: "Dropsride Facebook",
              );
            }
          },
        ),
        hSizedBox4,
        ContactButton(
          fa: true,
          title: 'Twitter',
          icon: FontAwesomeIcons.twitter,
          onPressed: () async {},
        ),
        hSizedBox4,
        ContactButton(
          fa: false,
          title: 'Instagram',
          icon: FontAwesomeIcons.instagram,
          onPressed: () async {
            final url = Uri(scheme: 'https', path: 'instagram.com/dropsride');
            // const url = 'https://dropsride.com';
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalNonBrowserApplication,
                webOnlyWindowName: "Dropsride Instagram",
              );
            }
          },
        ),
      ],
    );
  }
}
