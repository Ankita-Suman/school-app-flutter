import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 5),
                height: Dimens.threeHundredSeventyFive,
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: Dimens.edgeInsets20_55_20_10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: Get.back,
                              child: SizedBox(
                                  height: Dimens.twenty,
                                  width: Dimens.twenty,
                                  child: SvgPicture.asset(
                                      AssetConstants.icBackArrow,
                                      height: Dimens.twenty,
                                      width: Dimens.twenty,
                                      fit: BoxFit.scaleDown))),
                          Text(StringConstants.events,
                              style: Styles.white30B),
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
                              Dimens.boxHeight10,
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
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
                    height: Dimens.percentHeight(0.82),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: Dimens.edgeInsets5,
                        child: ListView.builder(
                            padding: Dimens.edgeInsets0,
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) => Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      index == 0
                                          ? Padding(
                                              padding:
                                                  Dimens.edgeInsets15_15_0_10,
                                              child: Text('Nov',
                                                  style: Styles.darkGry16))
                                          : Text('', style: Styles.darkGry0),
                                      Container(
                                        width: Dimens.percentWidth(1),
                                        margin: EdgeInsets.only(
                                            left: Dimens.ten,
                                            top: 0.0,
                                            right: Dimens.ten,
                                            bottom: Dimens.eight),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            )),
                                        child: Padding(
                                          padding: Dimens.edgeInsets10_0_0_0,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Science Exhibition',
                                                        style: Styles.black14,
                                                      ),
                                                      Padding(
                                                        padding: Dimens
                                                            .edgeInsets5_0_20_20,
                                                        child: Image.asset(
                                                            AssetConstants
                                                                .imgScience,
                                                            width:
                                                                Dimens.seventy,
                                                            height:
                                                                Dimens.seventy,
                                                            fit: BoxFit
                                                                .scaleDown),
                                                      )
                                                    ],
                                                  ),
                                                  Dimens.boxWidth5,
                                                  Padding(
                                                      padding: Dimens
                                                          .edgeInsets0_15_10_0,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SvgPicture.asset(
                                                                AssetConstants
                                                                    .icAlarm,
                                                              ),
                                                              Dimens.boxWidth5,
                                                              Padding(
                                                                  padding: Dimens
                                                                      .edgeInsets0_3_0_0,
                                                                  child: Text(
                                                                    '19 Nov 24, 09:00 AM',
                                                                    style: Styles
                                                                        .blue12w500,
                                                                  ))
                                                            ],
                                                          ),
                                                          Dimens.boxHeight5,
                                                          SizedBox(
                                                              width: Dimens
                                                                  .hundredEighty,
                                                              child: Padding(
                                                                  padding: Dimens
                                                                      .edgeInsets20_0_0_0,
                                                                  child: Text(
                                                                    'Another approach to defining science is as the information gained through practice.',
                                                                    style: Styles
                                                                        .blk12w400,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 4,
                                                                  )))
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
