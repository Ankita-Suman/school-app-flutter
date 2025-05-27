import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app.dart';
import '../home.dart';

class HomeWorkWidget extends StatelessWidget {
  const HomeWorkWidget({super.key});

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
                        Text(StringConstants.homeWork,style: Styles.white30B),
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
                    child:Padding(
                        padding: Dimens.edgeInsets10,
                        child:  ListView.builder(
                            padding: Dimens.edgeInsets0,
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Dimens.boxHeight10,
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
                                  Radius.circular(15),
                                ),
                                color: ColorsValue.lightSkyBgClr,
                                border: Border.all(
                                  color: ColorsValue.lightGryBgClr,
                                  width: 1,
                                )),
                            child: Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: Dimens.edgeInsets5,
                                        child: Image.asset(
                                            AssetConstants.imgDummy,
                                            width: Dimens.sixty,
                                            height: Dimens.sixty,
                                            fit: BoxFit.contain),
                                      ),
                                      Dimens.boxWidth10,
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Dimens.boxHeight5,
                                          Text(
                                            'Science',
                                            style: Styles.blackBold17,
                                          ),
                                          Dimens.boxHeight5,
                                          Text(
                                            'Label the Diagram of heart',
                                            style: Styles.black14,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]))
                  ),
                ),
              ))],
          ),
        ),
      ),
    );
  }

}