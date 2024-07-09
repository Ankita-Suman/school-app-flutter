import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../app.dart';
import '../home.dart';

class TimeTableWidget extends StatelessWidget {
  const TimeTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
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
                decoration: const BoxDecoration(
                ),
                child:  Padding(
                  padding: Dimens.edgeInsets20_55_20_10,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(StringConstants.timeTable,style: Styles.white30B),
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
                                      alignment: Alignment.bottomRight,
                                      child: SvgPicture.asset(
                                          AssetConstants.icHomeNotification)),
                                ),
                              ),
                              Dimens.boxWidth5,
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: SvgPicture.asset(
                                      AssetConstants.icUserLink)),
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
                      height: Dimens.percentHeight(0.75),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                          padding: Dimens.edgeInsets10,
                          child: SingleChildScrollView(
                              physics: const ScrollPhysics(),
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      Radius.circular(30),
                                    ),
                                    color: ColorsValue.whiteColor,
                                    border: Border.all(
                                      color: ColorsValue.borderGryBgClr,
                                      width: 1,
                                    )),
                                child: Padding(
                                  padding: Dimens.edgeInsets5_2_5_2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async{
                                          await showDatePicker(
                                            context: context,
                                            initialDate: controller.date,
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime(2030),
                                          ).then((selectedDate) {
                                            if (selectedDate != null) {
                                              controller.setDate(selectedDate);
                                            }
                                          }
                                          );
                                        },
                                        child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                         Padding(
                                            padding: Dimens.edgeInsets5,
                                            child: Text(
                                              controller.formattedDate.isEmpty?'Select Day':
                                              controller.formattedDate,
                                              style: Styles.dark14,
                                            ),
                                          ),
                                          Padding(
                                            padding: Dimens.edgeInsets5_2_5_2,
                                            child:  SvgPicture.asset(
                                            AssetConstants
                                                .icArrow,
                                           ),
                                          ),
                                        ],
                                      ),
                                      )],
                                  ),
                                ),
                              ),
                               Dimens.boxHeight10,
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     'Time',
                                     style: Styles.black14w600,
                                   ),
                                   Dimens.boxWidth10,
                                   Text(
                                     'Class',
                                     style: Styles.black14w600,
                                   ),
                                   Dimens.boxWidth10,
                                   Text(
                                     'Tuesday',
                                     style: Styles.black14w600,
                                   ),
                                 ],
                               ),
                              ListView.builder(
                                  padding: Dimens.edgeInsets15_30_20_0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:5,
                                  itemBuilder: (context, index) => Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '09:30',
                                              style: Styles.blackBold17,
                                            ),
                                            Text(
                                              '10:15',
                                              style: Styles.greyBold14,
                                            ),
                                          ],
                                        ),
                                        Dimens.boxWidth15,
                                        Column(children: <Widget>[
                                        index==0? Dimens.boxHeight20 :Dimens.box0,
                                          Container(
                                           padding: const EdgeInsets.only(top: 16),
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorsValue.primaryColor),
                                          ),
                                          Container(
                                            height: Dimens.hundred,
                                            width: 1,
                                          color: ColorsValue.primaryColor,),
                                          // Container(
                                          //   //margin: const EdgeInsets.only(top: 16),
                                          //   height: 10,
                                          //   width:10,
                                          //   decoration: BoxDecoration(
                                          //       shape: BoxShape.circle,
                                          //       color: ColorsValue.primaryColor),
                                          // ),
                                        ],
                                        ),
                                        Dimens.boxWidth15,
                                        Container(
                                         padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: ColorsValue.lightSkyBgClr,
                                              border: Border.all(
                                                color: ColorsValue.lightGryBgClr,
                                                width: 1,
                                              )),
                                          child:Padding(
                                            padding: Dimens.edgeInsets2_5_2_5,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                   Image.asset(
                                                          AssetConstants.icDummy,
                                                          width: Dimens.fourty,
                                                          height: Dimens.fourty,
                                                          fit: BoxFit.scaleDown),
                                                    Dimens.boxWidth5,
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Dimens.boxHeight5,
                                                        Text(
                                                          'Computer Science',
                                                          style: Styles.blackBold17,
                                                        ),
                                                        Dimens.boxHeight5,
                                                        Text(
                                                          'Anu',
                                                          style: Styles.black14,
                                                        ),
                                                      ],
                                                    ),
                                                    Dimens.boxWidth10,
                                                    SvgPicture.asset(
                                                        AssetConstants.icDots,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]))
                            ],
                          )
                      ),
                    ),
                  )))],
          ),
        ),
      ),
    );
  }
}

