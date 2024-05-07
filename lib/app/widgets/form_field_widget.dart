import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A form field widget which will handle form ui.
///
/// [focusNode] : FocusNode for the form field.
/// [autoFocus] : Allow auto focus for the form field if true.
/// [textEditingController] : Text editing controller for the form field
///                           to handle the text change and other stuff.
/// [isObscureText] : If true it will make the form text secure.
/// [obscureCharacter] : If [isObscureText] true this will be used for the
///                      character which will be shown.
/// [textCapitalization] : Type of text capitalization for the form field.
/// [isFilled] : If true the decoration colors will be filled.
/// [contentPadding] : Padding for the form field between the content and
///                    boundary of the form.
/// [fillColor] : The background color of the form field.
/// [hintText] : The hint text of the form field.
/// [hintStyle] : The hint style for the the form field.
/// [labelStyle] : The label style for the the form field.
/// [errorStyle] : The error style for the the form field.
/// [formBorder] : The border for the form field.
/// [errorText] : The error text of the form field.
/// [suffixIcon] : The suffix widget of the form field.
/// [prefixIcon] : The prefix widget of the form field.
/// [textInputAction] : The text input action for the form filed.
/// [textInputType] : The keyboard type of the form field.
/// [formStyle] : The style of the form field. This will be used for the style
///               of the content.
class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    super.key,
    this.focusNode,
    this.autoFocus = false,
    this.textEditingController,
    this.scrollPadding,
    this.focusedBorder,
    this.isObscureText = false,
    this.obscureCharacter = ' ',
    this.textCapitalization = TextCapitalization.none,
    this.isFilled,
    this.contentPadding = EdgeInsets.zero,
    this.fillColor,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.formBorder,
    this.formEnableBorder,
    this.errorText,
    this.constraints,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.formStyle,
    this.onChange,
    this.inputFormatters,
    this.cursorColor,
    this.isReadOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.floatingLabelBehavior,
    this.maxLength,
    this.fieldHeight,
    this.fieldWidth,
    this.initialValue,
    this.labelText,
    this.counterStyle,
    this.suffix,
    this.prefix,
    this.prefixIconConstraints,
    this.counterText,
    this.decoration,
    this.icon,
    this.onFieldSubmitted,
  });

  final FocusNode? focusNode;
  final bool autoFocus;
  final TextEditingController? textEditingController;
  final bool isObscureText;
  final String obscureCharacter;
  final TextCapitalization textCapitalization;
  final bool? isFilled;
  final int? maxLength;
  final EdgeInsets contentPadding;
  final Color? fillColor;
  final EdgeInsets? scrollPadding;
  final Color? cursorColor;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? counterStyle;
  final InputBorder? formBorder;
  final InputBorder? focusedBorder;
  final InputBorder? formEnableBorder;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? icon;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final TextStyle? formStyle;
  final void Function(String value)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final bool isReadOnly;
  final Function()? onTap;
  final int? maxLines;
  final double? fieldHeight;
  final double? fieldWidth;
  final String? initialValue;
  final BoxConstraints? constraints;
  final BoxConstraints? prefixIconConstraints;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Widget? suffix;
  final Widget? prefix;
  final InputDecoration? decoration;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onTap: onTap,
            maxLines: maxLines,
            key: const Key('text-form-field'),
            readOnly: isReadOnly,
            scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
            maxLength: maxLength,
            autofocus: autoFocus,
            cursorColor: cursorColor ?? ColorsValue.primaryColor,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            initialValue: initialValue,
            controller: textEditingController,
            obscureText: isObscureText,
            obscuringCharacter: obscureCharacter,
            textCapitalization: textCapitalization,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            enableInteractiveSelection: true,
            decoration: decoration ??
                InputDecoration(
                  alignLabelWithHint: true,
                  counterStyle: counterStyle,
                  // floatingLabelBehavior:
                  // floatingLabelBehavior ?? FloatingLabelBehavior.auto,
                  filled: true,
                  counterText: '',
                  contentPadding: contentPadding,
                  fillColor: fillColor ?? Colors.white,
                  suffix: suffix,
                  prefix: prefix,
                  icon: icon,
                  suffixIconConstraints: constraints ??
                      BoxConstraints(
                          minHeight: Dimens.thirty, minWidth: Dimens.thirty),
                  prefixIconConstraints: prefixIconConstraints ??
                      BoxConstraints(
                          minHeight: Dimens.thirty, minWidth: Dimens.thirty),
                  // border: formBorder ??
                  //     OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(Dimens.ten),
                  //       borderSide:
                  //       const BorderSide(color: Colors.grey),
                  //     ),
                  labelText: labelText,
                  //hintStyle: hintStyle,
                  labelStyle: labelStyle,
                  // hintText: labelText,
                  // disabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(Dimens.fifty),
                  //   ),
                  //   borderSide: const BorderSide(color: Colors.grey),
                  // ),
                  // enabledBorder: formEnableBorder ??
                  //     OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(Dimens.ten),
                  //       borderSide:
                  //       const BorderSide(color: Colors.grey),
                  //     ),
                  // focusedBorder: focusedBorder ??
                  //     OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(Dimens.ten),
                  //       borderSide:
                  //       const BorderSide(color: Colors.grey),
                  //     ),
                  // errorBorder: formEnableBorder ??
                  //     OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(Dimens.ten),
                  //       borderSide:
                  //       const BorderSide(color: Colors.grey),
                  //     ),
                  // focusedErrorBorder: formBorder ??
                  //     OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(Dimens.ten),
                  //       borderSide:
                  //       const BorderSide(color: Colors.grey),
                  //     ),
                  //errorText: errorText,
                  errorStyle: errorStyle ?? Styles.greyReg13,
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                ),
            onChanged: onChange,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            style: formStyle,
          ),
          if (errorText != null && errorText!.isNotEmpty) Dimens.boxHeight3,
          if (errorText != null && errorText!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Icon(Icons.warning_rounded,
                //     color: Colors.textFieldErrorColor, size: 20),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    errorText!.toString(),
                    maxLines: 10,
                    style: errorStyle ?? Styles.greyReg13,
                  ),
                ),
              ],
            ),
        ],
      );
}
