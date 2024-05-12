import 'dart:convert';
import 'dart:io' show Directory;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:school_app/app/app.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import '../../device/device.dart';
import '../../domain/domain.dart';

abstract class Utility {
  static Directory path = Directory('storage/emulated/0/Fanzly');

  // coverage:ignore-start
  static void printDLog(String message) {
    Logger().d('${'appName'.tr}: $message');
  }

  /// Print info log.
  ///
  /// [message] : The message which needed to be print.
  static void printILog(dynamic message) {
    Logger().i('${'appName'.tr}: $message');
  }

  static bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  /// Print info log.
  ///
  /// [message] : The message which needed to be print.
  static void printLog(dynamic message) {
    Logger().log(Level.info, message);
  }

  /// Get First word of a name.
  ///
  static String? getNameInitials(String? firstName, String? lastName) =>
      '${firstName![0]}${lastName![0]}'.toUpperCase();

  /// Print error log.
  ///
  /// [message] : The message which needed to be print.
  static void printELog(String message) {
    Logger().e('${'appName'.tr}: $message');
  }

  static const countryCode = '+51';

  /// Returns a error String by validating password.
  ///
  /// for at least one upper case, at least one digit,
  /// at least one special character and and at least 6 characters long
  /// return [List<bool>] for each case.
  /// Validation logic
  /// r'^
  ///   (?=.*[A-Z])             // should contain at least one upper case
  ///   (?=.*?[0-9])            // should contain at least one digit
  ///  (?=.*?[!@#\$&*~]).{8,}   // should contain at least one Special character
  /// $
  static String? validatePassword(String value) {
    if (value.trim().isNotEmpty) {
      if (value.contains(
          RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z])'))) {
        if (value.length < 8) {
          return StringConstants.shouldBe6Characters;
        } else {
          return null;
        }
      } else {
        return StringConstants.shouldBe6Characters.tr;
      }
    } else {
      return StringConstants.passwordRequired;
    }
  }



  /// Returns true if email is Valid
  static bool emailValidator(String email) => EmailValidator.validate(email);

  static bool phoneValidator(String phone) {
    // var pattern = r'^(?:[+0]9)?[0-9]{10}$';
    var pattern = r'^\+?(?:[ ()-]*\d){8,16}$';
    var regExp = RegExp(pattern);
    if (phone.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(phone)) {
      return false;
    }
    return true;
  }

  static bool notEmptyValidator(String? s) => s != null && s.trim().isNotEmpty;

  /// Check if URL is valid
  static bool urlValidator(String value) {
    var pattern =
        r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?';
    var regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  /// Returns true if the internet connection is available.
  static Future<bool> isNetworkAvailable() async =>
      await InternetConnectionChecker().hasConnection;

  /// Print the details of the [response].
  static void printResponseDetails(Response? response) {
    if (response != null) {
      var isOkay = response.isOk;
      var statusCode = response.statusCode;
      var statusText = response.statusText;
      var method = response.request?.method ?? '';
      var path = response.request?.url.path ?? '';
      var query = response.request?.url.queryParameters ?? '';
      if (isOkay) {
        printILog(
            'Path: $path, Method: $method, Status Text: $statusText, Status Code: $statusCode, Query $query');
      } else {
        printELog(
            'Path: $path, Method: $method, Status Text: $statusText, Status Code: $statusCode, Query $query');
      }
    }
  }

  /// returns the date time in particular given formate
  static String getWeekDayMonthNumYear(DateTime dateTime) =>
      DateFormat.yMMMMEEEEd().format(dateTime);

  /// get formated [DateTime] eg. 12-01-2021
  static String getDayMonthYear(DateTime dateTime) =>
      '${getOnlyDate(dateTime)}-${DateFormat('MM').format(dateTime)}-${DateFormat.y().format(dateTime)}';

  /// get formated [DateTime] eg. 12
  static String getOnlyDate(DateTime dateTime) =>
      DateFormat('dd').format(dateTime);

  /// get formated [DateTime] eg. 12 Sep
  static String getDateAndMonth(DateTime dateTime) =>
      DateFormat('dd MMM').format(dateTime);

  /// get formated [DateTime]
  static String getWeekDay(DateTime dateTime) =>
      DateFormat.EEEE().format(dateTime);

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int _numOfWeeks(int year) {
    var dec28 = DateTime(year, 12, 28);
    var dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  // Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int weekNumber(DateTime date) {
    var dayOfYear = int.parse(DateFormat('D').format(date));
    var woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  /// Show loader
  static void showLoader() async {
    await Get.dialog<dynamic>(
      Center(
        child: LoadingAnimationWidget.inkDrop(
          color: Colors.white,
          size: 60,
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.7),
    );
  }

  /// Close loader
  static void closeLoader() {
    closeDialog();
  }

  /// URL Launcher
  static void launchURL(String url) async =>
      await canLaunchUrl(Uri.parse(url))
          ? await canLaunchUrl(Uri.parse(url))
          : showDialog('Could not open $url');

  /// Show info dialog
  static void showDialog(
    String message, {
    Function()? onPress,
    bool barrierDismissible = true,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        title: Text('info'.tr),
        content: Text(
          message,
        ),
        actions: [
          CupertinoButton(
            onPressed: onPress ?? Get.back,
            child: Text(
              'okay'.tr,
              style: TextStyle(color: Theme.of(Get.context!).primaryColor),
            ),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show filter dialog
  static void showFilterDialog(
    String message, {
    Function()? onPress,
    bool barrierDismissible = true,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        content: Text(
          message,
        ),
        actions: [
          CupertinoButton(
            onPressed: onPress ?? Get.back,
            child: Text(
              'Ok'.tr,
              style: TextStyle(color: Theme.of(Get.context!).primaryColor),
            ),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show simple dialog for some time
  static void showSimpleDialog({
    required String subTitle,
    bool? barrierDismissible,
    int? duration,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    Function(bool)? isTimeOver,
  }) {
    Future<dynamic>.delayed(
      Duration(seconds: duration ?? 3),
    ).then((dynamic value) {
      isTimeOver!(true);
    });
    Get.dialog<dynamic>(
        CupertinoAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dimens.boxHeight10,
              SizedBox(
                width: Dimens.twoHundred,
                child: Text(
                  subTitle,
                  style: subTitleStyle ?? Styles.blackReg16,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: barrierDismissible ?? true);
  }

  /// Show alert dialog
  static void showAlertDialog({
    String? message,
    Function()? onPress,
    String? buttonText1,
    String? buttonText2,
    Function()? onButton2Press,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        content: Text('$message',style: Styles.blackEBold15,),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: onButton2Press ?? closeDialog,
            child: Text(buttonText2 ?? 'Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: true,
            onPressed: onPress,
            child: Text(buttonText1 ?? 'Logout'),
          ),
        ],
      ),
    );
  }

  /// Show giftCard dialog
  static void showGiftCardDialog({
    String? message,
    Function()? onPress,
    String? buttonText1,
    String? buttonText2,
    Function()? onButton2Press,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        content: Text('$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: onButton2Press ?? closeDialog,
            child: Text(buttonText2!),
          ),
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: onPress,
            child: Text(buttonText1!),
          ),
        ],
      ),
    );
  }

  /// Show alert dialog
  static void showDeleteAlertDialog({
    String? message,
    Function()? onPress,
    String? buttonText1,
    String? buttonText2,
    Function()? onButton2Press,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        content: Text('$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: onButton2Press ?? closeDialog,
            child: Text(buttonText2 ?? 'Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: true,
            onPressed: onPress,
            child: Text(buttonText1 ?? 'Delete'),
          ),
        ],
      ),
    );
  }

  /// Close any open dialog.
  static void closeDialog() {
    // if (Get.isDialogOpen ?? false) Get.back<dynamic>();
    debugPrint('Start: Close Dialog ${Get.isDialogOpen}');
    if (Get.isDialogOpen ?? true) {
      //   // Navigator.of(Get.context!, rootNavigator: true);
      Get.back<void>();
    }
    debugPrint('End: Close Dialog ${Get.isDialogOpen}');
  }

  /// Close any open snackbar
  static void closeSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.back<void>();
    }
  }

  /// Show no internet dialog if there is no
  /// internet available.
  static Future<void> showNoInternetDialog() async {
    await Get.dialog<void>(
      const NoInternetWidget(),
      barrierDismissible: false,
    );
  }

  /// Returns Platform type
  static String platFormType() {
    var value = kIsWeb
        ? 3
        : GetPlatform.isAndroid
            ? 1
            : 2;
    return value.toString();
  }

  /// Random number generator
  static int getRandomNumer() {
    var random = Random();
    return random.nextInt(100);
  }

  /// Return file size
  static String getFileSize(int size) {
    if (size == 0) {
      return '0 KB';
    } else {
      var val = size / pow(1024, (log(size) / log(1024)).floor());
      if (size < 1024) {
        return '$val KB';
      } else {
        return '${val.toStringAsFixed(1)} MB';
      }
    }
  }

  /// calculate percentage
  static int getPercentageValue(int propotionateValue, int totalValue) =>
      ((propotionateValue / totalValue) * 100).round();

  /// Get current location and update the view.
  // static Future<LocationDataLocal?> getCurrentLocation() async {
  //   var currentLocation = Location();
  //   final res = await currentLocation.hasPermission();
  //   printILog('res $res');

  //   if (res != PermissionStatus.granted) {
  //     await currentLocation.requestPermission();
  //   } else {
  //     var location = await currentLocation.getLocation();
  //     printLog('Lat: ${location.latitude} , Lng: ${location.longitude}');
  //     double? lat = location.latitude ?? 0.0;
  //     double? longi = location.longitude ?? 0.0;
  //     var locationDetails = await getAddressThroughLatLng(lat, longi);
  //     return getLocationData(
  //       locationDetails,
  //       lat,
  //       longi,
  //     );
  //   }
  //   return null;
  // }

  static String getFormatedDate(String date) {
    var date = DateTime.parse('2018-04-10T04:00:00.000Z');
    return Utility.getDayMonthYear(date);
  }

  /// Show error dialog from response model
  static void showInfoDialog(ResponseModel data,
      [bool isSuccess = false]) async {
    await Get.dialog<dynamic>(
      CupertinoAlertDialog(
        title: Text(isSuccess ? 'Success' : 'Invalid'),
        content: Text(
          jsonDecode(data.data)['message'] as String,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back<dynamic>();

              var code = jsonDecode(data.data)['statusCode'] as int;

              if (code == 401) {
                var repo = Get.find<DeviceRepository>();
                repo.deleteAllSecuredValues();
                repo.deleteBox();
                repo.deleteSecuredValue(DeviceConstants.profileData);

                //RouteManagement.goToLoginRegister(isPasswordReset: false);
              }
            },
            isDefaultAction: true,
            child: Text(
              'OK'.tr,
            ),
          ),
        ],
      ),
    );
  }

  static String imageOptimization({
    required String bucket,
    required String url,
    required int width,
    required int height,
    required int quality,
    bool progressive = true,
    bool mozjpeg = true,
    required int blur,
  }) {
    var map = '';
    if (blur == 0) {
      map =
          '{"bucket": "$bucket","key": "$url","edits": {"resize": {"width": $width},"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg}}}';
    } else {
      map =
          '{"bucket": "$bucket","key": "$url","edits": {"resize": {"width": $width},"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg},"blur": $blur}}';
    }
    var data = base64Encode(utf8.encode(map));
    return data;
  }

  static String imageOptimizationWithoutSize({
    required String bucket,
    required String key,
    required int quality,
    required bool progressive,
    required bool mozjpeg,
    required int blur,
  }) {
    var map = '';
    if (blur == 0) {
      map =
          '{"bucket": "$bucket","key": "$key","edits": {"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg}}}';
    } else {
      map =
          '{"bucket": "$bucket","key": "$key","edits": {"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg},"blur": $blur}}';
    }
    var data = base64Encode(utf8.encode(map));
    return data;
  }

  static void getReadMoreSheet({String? title, String? text}) {
    Get.bottomSheet<dynamic>(
      SafeArea(
        child: Container(
          height: Dimens.twoHundredEighty,
          constraints: const BoxConstraints(maxHeight: double.infinity),
          width: double.infinity,
          color: ColorsValue.greyColor,
          child: Padding(
            padding: Dimens.edgeInsets15_20_15_0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Styles.white23,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back<void>();
                        },
                        child: const Icon(
                          Icons.cancel,
                        ),
                      ),
                    ],
                  ),
                  Dimens.boxHeight30,
                  Text(
                    text!,
                    style: Styles.white14,
                  ),
                  Dimens.boxHeight10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Compare password & confirm password.
  ///
  static bool comparePasswords(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    }
    return false;
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
          SnackBar snackBar) =>
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar)
        ..closed.then(
          (value) => ScaffoldMessenger.of(Get.context!).clearSnackBars(),
        );

  /// Show Error bottomSheet.
  static void showErrorBottomSheet({
    required String? message,
    Function()? onPress,
    bool isDismissible = true,
    bool autoDismiss = true,
  }) async {
    await Get.bottomSheet<void>(
      Container(
        padding: Dimens.edgeInsets30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$message',
              style: Styles.blackBold16.copyWith(
                color: const Color.fromRGBO(235, 87, 87, 1),
              ),
            ),
            Dimens.boxHeight10,
            // CustomButton(
            //   width: Get.width - Dimens.sixty,
            //   onPress: onPress ?? Get.back,
            //   height: 50,
            //   title: 'ok'.tr,
            //   color: const Color.fromRGBO(235, 87, 87, 1),
            // ),
            // Dimens.boxHeight10,
          ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 206, 206, 1),
      isScrollControlled: true,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
    ).timeout(const Duration(seconds: 4), onTimeout: () {
      if (autoDismiss) {
        if (Get.isBottomSheetOpen!) {
          Get.back<void>();
        }
      }
    });

    // Get.snackbar(
    //   '',
    //   'message',
    //   // messageText: Container(
    //   //   color: Colors.red,
    //   //   height: 100,
    //   //   width: 100,
    //   // ),
    //   // titleText: Container(
    //   //   color: Colors.red,
    //   //   height: 100,
    //   //   width: 100,
    //   // ),
    //   barBlur: 0,
    //   backgroundColor: Colors.red,

    //   margin: Dimens.edgeInsets0,
    //   padding: Dimens.edgeInsets0,
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }

  static void datePickerDialog({
    required BuildContext context,
    required Function(DateTime, List<int>) onConfirm,
    DateTime? initialDateTime,
    DateTime? maxDateTime,
    DateTime? minDateTime,
    String dateFormat = 'MMMM-dd-yyyy',
  }) {
    DatePicker.showDatePicker(
      context,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      initialDateTime: initialDateTime ?? maxDateTime,
      dateFormat: dateFormat,
      onConfirm: onConfirm,
    );
  }

  static Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
    var codec = await ui.instantiateImageCodec(imgBytes);
    var frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<void> showAlertInfoDialog({
    String? message,
    String? title,
    String? buttonText,
    Function()? onPress,
    bool barrierDismissible = true,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onPress,
            child: Text(buttonText ?? 'Ok'),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // static void guestUserBottomSheet() async => Get.bottomSheet<dynamic>(
  //       // GetBuilder<HomeController>(
  //       //     builder: (_controller) =>
  //       Container(
  //         padding: Dimens.edgeInsets16_20_16_20,
  //         width: Dimens.percentWidth(1),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(
  //               Dimens.eight,
  //             ),
  //             topRight: Radius.circular(
  //               Dimens.eight,
  //             ),
  //           ),
  //           color: Colors.white,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Dimens.boxHeight16,
  //             RichText(
  //               maxLines: 1,
  //               softWrap: true,
  //               text: TextSpan(
  //                 children: [
  //                   TextSpan(
  //                     text: StringConstants.welcomeTo,
  //                     style: Styles.blackOnBoardSB20,
  //                   ),
  //                   TextSpan(
  //                     text: StringConstants.buki,
  //                     style: Styles.blackOnBoardBold20,
  //                   ),
  //                   WidgetSpan(
  //                     // alignment: PlaceholderAlignment.middle,
  //                     child: SizedBox(
  //                       width: Dimens.twentyFive,
  //                       height: Dimens.twentyFive,
  //                       child: Lottie.asset(
  //                         AssetConstants.wavyHand,
  //                         frameRate: FrameRate.max,
  //                         onLoaded: (LottieComposition d) {},
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Dimens.boxHeight25,
  //             // SizedBox(
  //             // width: Dimens.percentWidth(0.67),
  //             //   child:
  //             Padding(
  //               padding: Dimens.edgeInsets27_0_27_0,
  //               child: Text(
  //                 StringConstants.accessAllFeature,
  //                 style: Styles.blackReg14,
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //
  //             // ),
  //             Dimens.boxHeight45,
  //             FormSubmitWidget(
  //                 padding: Dimens.edgeInsets5,
  //                 buttonHeight: Dimens.fiftyFive,
  //                 text: StringConstants.registerLogin,
  //                 textStyle: Styles.whiteBold16,
  //                 buttonColor: ColorsValue.splashVioletColor,
  //                 borderRadius: Dimens.fifty,
  //                 onTap: () {
  //                   RouteManagement.goToLoginRegister(isPasswordReset: false);
  //                 }
  //                 // RouteManagement.goToForgotPassword,
  //                 ),
  //             Dimens.boxHeight30,
  //           ],
  //         ),
  //       ),
  //       isScrollControlled: true,
  //     );

  static String timeAgo(String createdAt) {
    var dateTime = DateTime.parse(createdAt);
    var result = dateTime.timeAgo(numericDates: false);
    return result;
  }

}
