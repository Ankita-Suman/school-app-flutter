import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  CustomOutlineButton({
    this.child,
    this.text,
    required this.isActive,
    this.backgroundColor = Colors.transparent,
    this.activeOutlineColor = ColorsValue.gryOutlineColor,
    this.inactiveOutlineColor = Colors.white,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.white,
    this.onPressed,
    this.height = 54.0,
    this.width = double.maxFinite,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    super.key,
  })  : assert(
            child != null || text != null, 'Either child Or text is required') {
    this.textStyle = textStyle ?? Styles.white18;
    this.borderRadius = borderRadius ?? BorderRadius.circular(Dimens.thirty);
  }

  final bool isActive;
  final Color activeOutlineColor;
  final Color inactiveOutlineColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color backgroundColor;
  final double height;
  final double width;
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  late final TextStyle textStyle;
  late final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(width, height)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: isActive ? activeOutlineColor : inactiveOutlineColor,
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        ),
        onPressed: isActive ? onPressed : null,
        child: (text is String
            ? Text(
                text!,
                style: textStyle,
              )
            : child)!,
      );
}
