import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


PreferredSizeWidget titleAppbar({
  String? title,
  Color? backgroundColor,
  double? elevation,
  double? leadingWidth,
  Color? shadowColor,
  TextStyle? titleStyle,
  Widget? leading,
  Widget? child,
  bool? centreTile,
  List<Widget>? actions,
  Function()? onTap,
}) {
  assert(title != null || child != null, 'Either child Or title is required');
  return AppBar(
    leading: leading ??
        InkWell(
          onTap: onTap ??
              () {
                Get.back<dynamic>();
              },
          child: Padding(
            padding: Dimens.edgeInsets8_10_8_10  ,
            child: SizedBox(
              height: Dimens.twentyFive,
              width: Dimens.twentyFive,
              child: SvgPicture.asset(
                AssetConstants.icArrowBack,
              ),
            ),
          ),
        ),
    actions: actions ?? [],
    backgroundColor: backgroundColor ?? Colors.white,
    centerTitle: centreTile ?? false,
    shadowColor: shadowColor,
    elevation: elevation ?? 1,
    automaticallyImplyLeading: false,
    leadingWidth: leadingWidth ?? Dimens.thirtySix,
    titleSpacing: 0,
    title: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child ?? Text(title!, style: titleStyle ?? Styles.blackSB18),
        Dimens.boxHeight2
      ],
    ),
  );
}
