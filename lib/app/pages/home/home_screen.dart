import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          color: ColorsValue.primaryTabColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18.0),
            child: GNav(
              backgroundColor: ColorsValue.primaryTabColor,
              color: Colors.white,
              activeColor: ColorsValue.primaryTabColor,
              tabBackgroundColor: Colors.white,
              gap: 8,
              padding: const EdgeInsets.all(14),
              tabs: [
                GButton(
                  iconSize: 28,
                  icon: Icons.home_filled,
                  text: StringConstants.home,
                  textStyle: Styles.skyBlueDark14,
                ),
                GButton(
                  iconSize: 28,
                  icon: Icons.account_balance_wallet,
                  text: StringConstants.homeWork,
                  textStyle: Styles.skyBlueDark14,
                ),
                GButton(
                  iconSize: 28,
                  icon: Icons.access_time_filled_rounded,
                  text: StringConstants.timeTable,
                  textStyle: Styles.skyBlueDark14,
                ),
                GButton(
                  iconSize: 28,
                  icon: Icons.calendar_month,
                  text: StringConstants.calender,
                  textStyle: Styles.skyBlueDark14,
                ),
              ],
            ),
          ),
        ),
        body: GetBuilder<HomeController>(
          builder: (controller) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AssetConstants.appLogo,
                    width: Dimens.threeHundred,
                    height: Dimens.twoHundredFifty,
                    fit: BoxFit.cover),
              ],
            ),
          ),
        ),
      );
}
