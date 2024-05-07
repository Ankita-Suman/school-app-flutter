import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      GetBuilder<HomeController>(
        builder: (controller) =>
            Scaffold(
              key: controller.scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      controller.scaffoldKey.currentState?.openDrawer();
                    },
                    icon: SvgPicture.asset(AssetConstants.icMenu)),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: Dimens.edgeInsets0_5_0_0,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: SvgPicture.asset(
                                  AssetConstants.icHomeNotification)),
                        ),
                        Dimens.boxWidth5,
                        Align(
                            alignment: Alignment.bottomRight,
                            child: SvgPicture.asset(AssetConstants.icUserLink)),
                        Dimens.boxHeight10,
                      ],
                    ),
                  ],
                ),
                backgroundColor: ColorsValue.primaryTabColor,
              ),
              drawer: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width *
                    0.95, // 75% of screen will be occupied
                child: Drawer(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                            color: ColorsValue.primaryTabColor,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0.0, 0.0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 0.0,
                              ),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.scaffoldKey.currentState
                                    ?.closeDrawer();
                              },
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: SvgPicture.asset(AssetConstants
                                      .icCross)),
                            ),
                            Dimens.boxHeight5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Anmol Singh',
                                      style: Styles.white16,
                                    ),
                                    Text(
                                      'Class II-B | Roll no: 04',
                                      style: Styles.white8,
                                    ),
                                    Dimens.boxHeight15,
                                    FormSubmitWidget(
                                      padding: Dimens.edgeInsets8,
                                      buttonHeight: Dimens.thirty,
                                      buttonWidth: Dimens.hundred,
                                      text: StringConstants.viewProfile,
                                      textStyle: Styles.lightBlueDark10,
                                      buttonColor: ColorsValue.whiteColor,
                                      borderRadius: Dimens.thirty,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                Image.asset(AssetConstants.icPhoto,
                                    width: Dimens.hundred,
                                    height: Dimens.hundred,
                                    fit: BoxFit.fill),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: Dimens.edgeInsets10,
                          child: Text(
                            StringConstants.academics,
                            style: Styles.darkBlueDark16,
                          )),
                      Dimens.boxHeight5,
                      Container(
                        padding: Dimens.edgeInsets5,
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: controller.academicList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 3.0,
                              childAspectRatio: 1.1,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        controller.academicList[index].image),
                                    Dimens.boxHeight15,
                                    Text(
                                      controller.academicList[index].name
                                          .toString(),
                                      style: Styles.darkBlueLight14,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                      ),
                      Padding(
                          padding: Dimens.edgeInsets10,
                          child: Text(
                            StringConstants.others,
                            style: Styles.darkBlueDark16,
                          )),
                      Dimens.boxHeight5,
                      Container(
                        padding: Dimens.edgeInsets5,
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: controller.othersList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 3.0,
                              childAspectRatio: 1.1,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        controller.othersList[index].image),
                                    Dimens.boxHeight15,
                                    Text(
                                      controller.othersList[index].name
                                          .toString(),
                                      style: Styles.darkBlueLight14,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                      ),
                    ],
                  ),
                ),
              ),
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
                  builder: (controller) =>
                      Stack(
                        children: <Widget>[
                          Container(
                            color: ColorsValue.primaryTabColor,
                            padding: const EdgeInsets.only(top: 5),
                            height: Dimens.percentHeight(0.9),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: Dimens.edgeInsets20_0_10_0,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Anmol Singh',
                                              style: Styles.white20,
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              'Class II-B  |  Roll no: 04',
                                              style: Styles.white12,
                                              textAlign: TextAlign.start,
                                            ),
                                            Dimens.boxHeight15,
                                            FormSubmitWidget(
                                              buttonHeight: Dimens.twenty,
                                              buttonWidth: Dimens.ninty,
                                              text: '2004-2005',
                                              textStyle: Styles.lightBlueDark10,
                                              buttonColor: ColorsValue
                                                  .whiteColor,
                                              borderRadius: Dimens.thirty,
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                        Image.asset(AssetConstants.icPhoto,
                                            width: Dimens.eighty,
                                            height: Dimens.eighty,
                                            fit: BoxFit.fill),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)),
                              child: Container(
                                width: Dimens.percentWidth(1),
                                height: Dimens.percentHeight(0.55),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Padding(
                                            padding: Dimens
                                                .edgeInsets24_15_24_10,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    StringConstants.noticeBoard,
                                                    style: Styles.blue20),
                                                Dimens.boxHeight5,
                                                Container(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 5, bottom: 5),
                                                  height: Dimens.hundredFifty,
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        AssetConstants
                                                            .icNoticeBoardBg,
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: Dimens
                                                        .edgeInsets15_10_15_10,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top: 1),
                                                          height: Dimens
                                                              .hundredFifty,
                                                          width: Dimens
                                                              .hundredFourty,
                                                          decoration: BoxDecoration(
                                                              color: ColorsValue
                                                                  .lightSkyBlueB,
                                                              borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                      5))),
                                                          child: Padding(
                                                            padding: Dimens
                                                                .edgeInsets3,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  AssetConstants
                                                                      .icCrossNotice,
                                                                  height: Dimens
                                                                      .fifteen,
                                                                  width: Dimens
                                                                      .fifteen,
                                                                ),
                                                                Dimens
                                                                    .boxHeight8,
                                                                Container(
                                                                    height: Dimens
                                                                        .fourty,
                                                                    width: Dimens
                                                                        .hundredThirtyFive,
                                                                    decoration: const BoxDecoration(
                                                                        color: ColorsValue
                                                                            .whiteColor,
                                                                        borderRadius: BorderRadius
                                                                            .all(
                                                                            Radius
                                                                                .circular(
                                                                                2))),
                                                                    child: Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                            'Drawing Competition',
                                                                            style: Styles
                                                                                .darkBlueDark12),
                                                                        Text(
                                                                            'on 28 June 2024',
                                                                            style: Styles
                                                                                .darkBlueDark12w600),
                                                                      ],
                                                                    )),
                                                                Dimens
                                                                    .boxHeight10,
                                                                Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    child: Text(
                                                                      StringConstants
                                                                          .registerYourSelf,
                                                                      style: Styles
                                                                          .black12w400,
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Dimens.boxWidth8,
                                                        Container(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top: 1),
                                                          height: Dimens
                                                              .hundredFifty,
                                                          width: Dimens
                                                              .hundredFourty,
                                                          decoration: BoxDecoration(
                                                              color: ColorsValue
                                                                  .lightSkyBlueB,
                                                              borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                      5))),
                                                          child: Padding(
                                                            padding: Dimens
                                                                .edgeInsets3,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  AssetConstants
                                                                      .icCrossNotice,
                                                                  height: Dimens
                                                                      .fifteen,
                                                                  width: Dimens
                                                                      .fifteen,
                                                                ),
                                                                Dimens
                                                                    .boxHeight8,
                                                                Container(
                                                                    height: Dimens
                                                                        .fourty,
                                                                    width: Dimens
                                                                        .hundredThirtyFive,
                                                                    decoration: const BoxDecoration(
                                                                        color: ColorsValue
                                                                            .whiteColor,
                                                                        borderRadius: BorderRadius
                                                                            .all(
                                                                            Radius
                                                                                .circular(
                                                                                2))),
                                                                    child: Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                            'Math Olympiad',
                                                                            style: Styles
                                                                                .darkBlueDark12),
                                                                        Text(
                                                                            'on 3 July 2024',
                                                                            style: Styles
                                                                                .darkBlueDark12w600),
                                                                      ],
                                                                    )),
                                                                Dimens
                                                                    .boxHeight10,
                                                                Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    child: Text(
                                                                      StringConstants
                                                                          .registerYourSelf,
                                                                      style: Styles
                                                                          .black12w400,
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Dimens.boxHeight10,
                                                Align(
                                                  alignment: Alignment
                                                      .bottomRight,
                                                  child: FormSubmitWidget(
                                                    buttonHeight: Dimens.thirty,
                                                    buttonWidth: Dimens.seventy,
                                                    text: StringConstants
                                                        .viewAll,
                                                    textStyle: Styles
                                                        .lightSky12w400,
                                                    buttonColor:
                                                    ColorsValue
                                                        .signInButtonColor,
                                                    borderRadius: Dimens.fourty,
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: Dimens
                                                  .edgeInsets24_15_24_10,
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(StringConstants
                                                        .homeWork,
                                                        style: Styles.blue20),
                                                    Dimens.boxHeight5,
                                                    SizedBox(
                                                      height: Dimens
                                                          .hundredEighty,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                          Axis.horizontal,
                                                          itemCount: 3,
                                                          itemBuilder:
                                                              (context,
                                                              index) =>
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right: 10),
                                                                      height: Dimens
                                                                          .hundredEighty,
                                                                      width: Dimens
                                                                          .hundredNinty,
                                                                      decoration: BoxDecoration(
                                                                          color: ColorsValue
                                                                              .lightBlueBbg,
                                                                          borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  5))),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .start,
                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: Dimens
                                                                                .edgeInsets8,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Text(
                                                                                    'Maths',
                                                                                    style: Styles
                                                                                        .darkBlue16w700),
                                                                                Text(
                                                                                    '23 July',
                                                                                    style: Styles
                                                                                        .darkBlue12w700),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Dimens
                                                                              .boxHeight10,
                                                                          Padding(
                                                                            padding: Dimens
                                                                                .edgeInsets8,
                                                                            child: Text(
                                                                                'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.',
                                                                                style: Styles
                                                                                    .darkBlue12),),
                                                                          Align(
                                                                              alignment: Alignment
                                                                                  .bottomCenter,
                                                                              child: Container(
                                                                                  padding: const EdgeInsets
                                                                                      .only(
                                                                                      top: 10),
                                                                                  height: Dimens
                                                                                      .thirty,
                                                                                  width: Dimens
                                                                                      .percentWidth(
                                                                                      1),
                                                                                  decoration: const BoxDecoration(
                                                                                      color: ColorsValue
                                                                                          .signInButtonColor,
                                                                                      borderRadius:
                                                                                      BorderRadius
                                                                                          .only(
                                                                                          bottomLeft: Radius
                                                                                              .circular(
                                                                                              5),
                                                                                          bottomRight: Radius
                                                                                              .circular(
                                                                                              5))),
                                                                                  child: Text(
                                                                                      '')
                                                                              )
                                                                          )
                                                                        ],
                                                                      )
                                                                  ),
                                                                ],
                                                              )),
                                                    ),
                                                  ]))
                                        ],
                                      ),)
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
            ),
      );
}
