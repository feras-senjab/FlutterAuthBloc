import 'package:flutter_auth_bloc/Global/Style/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Color? labelColor;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? hint;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Function? onTap;
  final TextCapitalization? textCapitalization;
  final Color? fillColor;
  final EdgeInsets? padding;
  final Widget? counter;
  final TextStyle? hintStyle;
  final InputBorder? inputBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? errorText;

  const EntryField({
    super.key,
    this.controller,
    this.label,
    this.labelColor,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.prefix,
    this.maxLines,
    this.suffixIcon,
    this.onTap,
    this.textCapitalization,
    this.fillColor,
    this.padding,
    this.counter,
    this.hintStyle,
    this.inputBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.textAlign,
    this.textStyle,
    this.onChanged,
    this.obscureText = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: 1.w,
          ),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText,
        style: textStyle ??
            TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
            ),
        enableInteractiveSelection: true,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        cursorColor: kMainColor,
        onTap: onTap as void Function()?,
        autofocus: false,
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        minLines: 1,
        maxLength: maxLength,
        maxLines: obscureText ? 1 : maxLines,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 3.w,
          ),
          filled: true,
          fillColor: fillColor ?? Colors.transparent,
          prefixIcon: prefix,
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(
            color: labelColor ?? Colors.black.withOpacity(0.5),
            fontSize: 16.sp,
          ),
          hintText: hint,
          hintStyle: hintStyle ??
              TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
          errorText: errorText,
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 11.sp,
          ),
          errorMaxLines: 3,
          counter: counter ?? const Offstage(),
          border: inputBorder ??
              const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: enabledBorder ?? inputBorder,
          focusedBorder: focusedBorder ?? inputBorder,
        ),
      ),
    );
  }
}
