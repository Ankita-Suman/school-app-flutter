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
/// [errorStyle] : The error style for the the form field.
/// [formBorder] : The border for the form field.
/// [errorText] : The error text of the form field.
/// [suffixIcon] : The suffix widget of the form field.
/// [prefixIcon] : The prefix widget of the form field.
/// [textInputAction] : The text input action for the form filed.
/// [textInputType] : The keyboard type of the form field.
/// [formStyle] : The style of the form field. This will be used for the style
///               of the content.
class FormFieldSearchWidget extends StatelessWidget {
  const FormFieldSearchWidget({
    Key? key,
    this.focusNode,
    this.autoFocus = false,
    this.textEditingController,
    this.isObscureText = false,
    this.obscureCharacter = ' ',
    this.textCapitalization = TextCapitalization.none,
    this.isFilled,
    this.contentPadding,
    this.fillColor,
    this.hintText,
    // this.onFieldSubmitted,
    this.hintStyle,
    this.errorStyle,
    this.formBorder,
    this.focusedBorder,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.formStyle,
    this.onChange,
    this.isReadOnly = false,
    this.onTap,
    this.errorBorder,
    this.inputFormatters,
    this.maxLength = TextField.noMaxLength,
    this.onEditingComplete,
    this.initialValue,
    this.cursorColor,
    this.maxlines = 1,
    this.enabled = true,
    this.validator,
    this.textAlign,
    this.onSubmitted,
  }) : super(key: key);

  final FocusNode? focusNode;
  final bool autoFocus;
  final TextEditingController? textEditingController;
  final bool isObscureText;
  final String obscureCharacter;
  final TextCapitalization textCapitalization;
  final bool? isFilled;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final InputBorder? formBorder;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final TextStyle? formStyle;
  final void Function(String value)? onChange;
  final void Function(String value)? onSubmitted;
  final bool isReadOnly;
  final Function()? onTap;
  final InputBorder? errorBorder;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? focusedBorder;
  final Function()? onEditingComplete;
  final int? maxLength;
  final String? initialValue;
  final Color? cursorColor;
  final int? maxlines;
  final bool? enabled;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => TextFormField(
        key: const Key('text-form-field'),
        readOnly: isReadOnly,
        onFieldSubmitted: onSubmitted,
        maxLength: maxLength,
        validator: validator,
        autofocus: autoFocus,
        focusNode: focusNode,
        textAlign: textAlign ?? TextAlign.left,
        controller: textEditingController,
        obscureText: isObscureText,
        // onFieldSubmitted: onFieldSubmitted,
        obscuringCharacter: obscureCharacter,
        textCapitalization: textCapitalization,
        onTap: onTap,
        inputFormatters: inputFormatters,
        cursorColor: cursorColor,
        decoration: InputDecoration(
            focusedBorder: focusedBorder ??
                UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsValue.primaryColor)),
            //  ??
            //     OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(Dimens.fifty),
            //       borderSide: const BorderSide(color: Colors.green),
            //     ),
            errorBorder: errorBorder ?? InputBorder.none,
            filled: true,
            contentPadding: contentPadding ?? Dimens.edgeInsets10,
            fillColor: fillColor ?? Colors.transparent,
            border: formBorder ??
                UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsValue.primaryColor)),
            //  ??
            //     OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(Dimens.fifty),
            //       borderSide: const BorderSide(color: Colors.green),
            //     ),
            enabledBorder: formBorder ??
                UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsValue.primaryColor)),
            //  ??
            //     OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(Dimens.fifty),
            //       borderSide: const BorderSide(color: Colors.green),
            //     ),
            hintText: hintText,
            hintStyle: hintStyle,
            errorText: errorText,
            errorStyle: errorStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorMaxLines: 3,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 25,
              minHeight: 25,
            ),
            counter: Dimens.box0),
        onChanged: onChange,
        maxLines: maxlines,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        style: formStyle ?? Styles.green16,
        onEditingComplete: onEditingComplete,
        initialValue: initialValue,
        enabled: enabled,
      );
}
