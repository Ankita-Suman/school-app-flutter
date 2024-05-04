import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';

/// A widget which will be used in the forms to allow user to submit the
/// details which were filled by the user.
///
/// [opacity] : The opacity of the widget to show that the widget is not enabled.
/// [disableColor] : The disable color of the widget.
/// [padding] : The padding around the content of the widget.
/// [onTap] : The tap event which will be triggered.
/// [text] : The text which will be shown.
/// [textStyle] : The style of the [text].
class FormSubmitWidget extends StatelessWidget {
  FormSubmitWidget({
    Key? key,
    this.opacity = 1,
    this.disableColor,
    this.startColor,
    this.endColor,
    this.buttonColor,
    this.buttonWidth,
    this.iconPath,
    this.iconColor,
    this.borderWidth,
    this.borderColor,
    this.padding,
    this.onTap,
    required this.text,
    this.textStyle,
    this.autoFocus = false,
    this.isIconShowLeft = false,
    this.buttonHeight,
    this.borderRadius,
  }) : super(key: key);

  final double opacity;
  final Color? disableColor;
  final Color? startColor;
  final Color? endColor;
  final Color? buttonColor;
  final double? buttonWidth;
  final String? iconPath;
  final Color? iconColor;
  final double? borderWidth;
  final Color? borderColor;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final String? text;
  final TextStyle? textStyle;
  final bool autoFocus;
  final bool isIconShowLeft;
  final double? buttonHeight;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) => Opacity(
      opacity: opacity,
      child: Container(
        height: buttonHeight ?? Dimens.fourtyEight,
        width: buttonWidth ?? Dimens.percentWidth(1),
        decoration: BoxDecoration(
          // boxShadow: [
          //   const BoxShadow(
          //       color: Colors.black12, offset: Offset(0, 2), blurRadius: 2.0)
          // ],
          border: Border.all(
              width: borderWidth ?? 0,
              color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? Dimens.ten),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? Dimens.ten),
              ),
            ),
            padding: padding == null
                ? MaterialStateProperty.all<EdgeInsetsGeometry>(
                Dimens.edgeInsets0)
                : MaterialStateProperty.all<EdgeInsetsGeometry>(padding!),
            //minimumSize: MaterialStateProperty.all(Size(width, 50)),
            backgroundColor: MaterialStateProperty.all(buttonColor),

          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text!,
                style: textStyle,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ));
}
