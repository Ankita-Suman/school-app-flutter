import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app.dart';
import '../home.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      GetBuilder<HomeController>(builder: (controller) =>
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
                        InkWell(
                          onTap: (){
                            RouteManagement.goToNotifications();
                          },
                          child: Padding(
                            padding: Dimens.edgeInsets0_5_0_0,
                            child: Align(
                                alignment:Alignment.bottomRight,
                                child: SvgPicture.asset(
                                    AssetConstants.icHomeNotification)),
                          ),
                        ),
                        Dimens.boxWidth5,
                        InkWell(
                            onTap: (){
                              RouteManagement.goToProfile();
                            },
                            child:  Align(
                                alignment: Alignment.bottomRight,
                                child:SvgPicture.asset(
                                    AssetConstants.icUserLink)
                            )
                        ),
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
                    0.95,
                child: Drawer(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimens.twoHundredTwentyFive,
                        child: DrawerHeader(
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Anmol Singh',
                                          style: Styles.white16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Class II-B | Roll no: 04',
                                          style: Styles.white8,
                                          overflow: TextOverflow.ellipsis,
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
                                          onTap: () {
                                            RouteManagement.goToEvents();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(AssetConstants.icPhoto,
                                      width: Dimens.hundred,
                                      height: Dimens.hundred,
                                      fit: BoxFit.cover),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: Dimens.edgeInsets0,
                          children: <Widget>[
                            Padding(
                                padding: Dimens.edgeInsets15_10_15_10,
                                child: Text(
                                  StringConstants.academics,
                                  style: Styles.darkBlueDark16,
                                )),
                            Dimens.boxHeight5,
                            Container(
                              padding: Dimens.edgeInsets8,
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
                                            controller.academicList[index].image,
                                            height: 40,
                                            width: 40,
                                          ),
                                          Dimens.boxHeight15,
                                          Text(
                                            controller.academicList[index].name.toString(),
                                            style: Styles.darkBlueLight14,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                            ),
                            Padding(
                                padding: Dimens.edgeInsets15_10_15_10,
                                child: Text(
                                  StringConstants.others,
                                  style: Styles.darkBlueDark16,
                                )),
                            Dimens.boxHeight5,
                            Container(
                              padding: Dimens.edgeInsets8,
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
                                    InkWell(
                                        onTap: () {
                                          if (index == 7) {
                                            Utility.showAlertDialog(
                                                onPress: () {
                                                  Get.back<dynamic>();
                                                  RouteManagement.goToChooseOptions();
                                                },
                                                message: StringConstants.logoutFromDevice);
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              controller.othersList[index].image,
                                              height: 40,
                                              width: 40,
                                            ),
                                            Dimens.boxHeight15,
                                            Text(
                                              controller.othersList[index].name.toString(),
                                              style: Styles.darkBlueLight14,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    color: ColorsValue.primaryTabColor,
                    padding: const EdgeInsets.only(top: 5),
                    height: Dimens.percentHeight(0.35), // Reduced height
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: Dimens.edgeInsets20_0_10_0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Anmol Singh',
                                        style: Styles.white20,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Class II-B  |  Roll no: 04',
                                        style: Styles.white12,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Dimens.boxHeight15,
                                      FormSubmitWidget(
                                        buttonHeight: Dimens.twenty,
                                        buttonWidth: Dimens.ninty,
                                        text: '2004-2005',
                                        textStyle: Styles.lightBlueDark10,
                                        buttonColor: ColorsValue.whiteColor,
                                        borderRadius: Dimens.thirty,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(AssetConstants.icPhoto,
                                    width: Dimens.ninty,
                                    height: Dimens.ninty,
                                    fit: BoxFit.cover),
                              ],
                            )),
                        SvgPicture.asset(AssetConstants.seekbar),
                        Dimens.boxHeight10,
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                      child: Container(
                        width: Dimens.percentWidth(1),
                        height: Dimens.percentHeight(0.65), // Increased height
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: Dimens.edgeInsets24_15_24_10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(StringConstants.noticeBoard, style: Styles.blue20),
                                    Dimens.boxHeight5,
                                    Container(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                      height: Dimens.hundredFifty,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(AssetConstants.icNoticeBoardBg),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets15_10_15_10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(top: 1),
                                                height: Dimens.hundredFifty,
                                                decoration: BoxDecoration(
                                                    color: ColorsValue.lightSkyBlueB,
                                                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets3,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(AssetConstants.icCrossNotice,
                                                        height: Dimens.fifteen,
                                                        width: Dimens.fifteen,
                                                      ),
                                                      Dimens.boxHeight8,
                                                      Container(
                                                          height: Dimens.fourty,
                                                          width: double.infinity,
                                                          decoration: const BoxDecoration(
                                                              color: ColorsValue.whiteColor,
                                                              borderRadius: BorderRadius.all(Radius.circular(2))),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text('Drawing Competition', style: Styles.darkBlueDark12),
                                                              Text('on 28 June 2024', style: Styles.darkBlueDark12w600),
                                                            ],
                                                          )),
                                                      Dimens.boxHeight10,
                                                      Align(
                                                          alignment: Alignment.center,
                                                          child: Text(StringConstants.registerYourSelf,
                                                            style: Styles.black12w400,
                                                            textAlign: TextAlign.center,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxWidth8,
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(top: 1),
                                                height: Dimens.hundredFifty,
                                                decoration: BoxDecoration(
                                                    color: ColorsValue.lightSkyBlueB,
                                                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets3,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(AssetConstants.icCrossNotice,
                                                        height: Dimens.fifteen,
                                                        width: Dimens.fifteen,
                                                      ),
                                                      Dimens.boxHeight8,
                                                      Container(
                                                          height: Dimens.fourty,
                                                          width: double.infinity,
                                                          decoration: const BoxDecoration(
                                                              color: ColorsValue.whiteColor,
                                                              borderRadius: BorderRadius.all(Radius.circular(2))),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text('Math Olympiad', style: Styles.darkBlueDark12),
                                                              Text('on 3 July 2024', style: Styles.darkBlueDark12w600),
                                                            ],
                                                          )),
                                                      Dimens.boxHeight10,
                                                      Align(
                                                          alignment: Alignment.center,
                                                          child: Text(StringConstants.registerYourSelf,
                                                            style: Styles.black12w400,
                                                            textAlign: TextAlign.center,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Dimens.boxHeight10,
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: FormSubmitWidget(
                                        buttonHeight: Dimens.thirty,
                                        buttonWidth: Dimens.seventy,
                                        text: StringConstants.viewAll,
                                        textStyle: Styles.lightSky12w400,
                                        buttonColor: ColorsValue.signInButtonColor,
                                        borderRadius: Dimens.fourty,
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: Dimens.edgeInsets24_15_24_10,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(StringConstants.events, style: Styles.blue20),
                                          Text('${controller.selectedSliderIndex}/10', style: Styles.blk10w400),
                                        ],
                                      ),
                                      Dimens.boxHeight10,
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          initialPage: 0,
                                          autoPlay: true,
                                          aspectRatio: 2.0,
                                          height: Dimens.percentHeight(0.35),
                                          viewportFraction: 1,
                                          autoPlayInterval: const Duration(seconds: 4),
                                          onPageChanged: (index, reason) {
                                            controller.onSliderChanged(index);
                                          },
                                        ),
                                        items: controller.eventsList.map<Widget>((i) =>
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 10),
                                                  height: Dimens.hundredFifty,
                                                  width: double.infinity,
                                                  child: Image(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(i.image),
                                                  ),
                                                ),
                                                Dimens.boxHeight10,
                                                Text(i.name, style: Styles.blk12),
                                                Dimens.boxHeight20,
                                                Text(i.dec, style: Styles.blue12),
                                              ],
                                            )
                                        ).toList(),
                                      ),
                                      Dimens.boxHeight25,
                                      Align(
                                          alignment: Alignment.center,
                                          child: DotsIndicator(
                                            dotsCount: controller.eventsList.length,
                                            decorator: DotsDecorator(
                                              color: Colors.grey,
                                              activeColor: ColorsValue.primaryColor,
                                              size: const Size.square(9.0),
                                              activeSize: const Size(18.0, 9.0),
                                              activeShape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0)),
                                            ),
                                          )
                                      )
                                    ]
                                ),
                              ),
                              Dimens.boxHeight15,
                              Padding(
                                padding: Dimens.edgeInsets24_0_24_0,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(StringConstants.homeWork, style: Styles.blue20),
                                      Dimens.boxHeight10,
                                      SizedBox(
                                        height: Dimens.twoHundred,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 3,
                                            itemBuilder: (context, index) =>
                                                Container(
                                                  margin: const EdgeInsets.only(right: 10),
                                                  width: Dimens.hundredNinty,
                                                  decoration: BoxDecoration(
                                                      color: ColorsValue.lightBlueBbg,
                                                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: Dimens.edgeInsets8,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Maths', style: Styles.darkBlue16w700),
                                                            Text('23 July', style: Styles.darkBlue12w700),
                                                          ],
                                                        ),
                                                      ),
                                                      Dimens.boxHeight10,
                                                      Padding(
                                                        padding: Dimens.edgeInsets8,
                                                        child: Text(
                                                          'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod.',
                                                          style: Styles.darkBlue12,
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                          padding: const EdgeInsets.only(top: 7, bottom: 3),
                                                          height: Dimens.thirtyFive,
                                                          width: double.infinity,
                                                          decoration: const BoxDecoration(
                                                              color: ColorsValue.signInButtonColor,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(5),
                                                                  bottomRight: Radius.circular(5))),
                                                          child: Text(
                                                            StringConstants.submitAssignment,
                                                            style: Styles.lightBlue12,
                                                            textAlign: TextAlign.center,
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                )
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: FormSubmitWidget(
                                          buttonHeight: Dimens.thirty,
                                          buttonWidth: Dimens.seventy,
                                          text: StringConstants.viewAll,
                                          textStyle: Styles.lightSky12w400,
                                          buttonColor: ColorsValue.signInButtonColor,
                                          borderRadius: Dimens.fourty,
                                          onTap: () {},
                                        ),
                                      ),
                                      Dimens.boxHeight20,
                                    ]
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          )
      );
}