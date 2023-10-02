

import 'package:dropsride/settings%20and%20legals/view_models/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../common_widgets/appbar_title.dart';
import '../../../constants/size.dart';
import '../constant/colors.dart';
import '../constant/size.config.dart';
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin, RestorationMixin {
  TabController? _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'help_center';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController!.index = tabIndex.value;
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      initialIndex: 1,
      vsync: this,
    );
    _tabController!.addListener(() {
      // when tab's controller value is updated make sure to update the tab index value, which is state restorable
      setState(() {
        tabIndex.value = _tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(
        child: SizedBox(
          width: SizeConfig.screenWidth / 3,
          child: Text(
            'FAQs',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ),
      Tab(
        child: SizedBox(
          width: SizeConfig.screenWidth / 3,
          child: Text(
            'Contact Us',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      )
    ];
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
        titleSpacing: AppSizes.padding,
        elevation: 0,
        title: const AppBarTitle(
          pageTitle: 'Help Center',
        ),
        bottom: TabBar(
          automaticIndicatorColorAdjustment: true,
          indicatorColor: AppColors.primaryColor,
          dividerColor: Theme.of(context).colorScheme.onBackground,
          controller: _tabController,
          isScrollable: true,
          tabs: tabs,
        ),
      ),

      // body
      body: TabBarView(controller: _tabController, children: [
        const ContactUs(),
      ]),
    );
  }
}
