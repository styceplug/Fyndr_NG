import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';

import '../utils/dimensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final bool obscureText;
  final List<String>? autofillHints;
  final bool enabled;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final Color? textColor;
  final Color? fillColor;
  final int? maxLines;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.textColor,
    this.fillColor,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.onChanged,
    this.autofillHints,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use theme-based colors
    final Color effectiveTextColor = textColor ?? Colors.black;
    final Color fillColor = this.fillColor ??
        (isDark ? Colors.white10 : AppColors.grey2.withOpacity(0.5));
    final Color borderColor = theme.dividerColor.withOpacity(0.2);
    final Color focusColor = theme.colorScheme.primary.withOpacity(0.6);
    final Color enabledBorderColor = theme.colorScheme.secondary.withOpacity(0.2);

    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      style: TextStyle(color: effectiveTextColor,fontFamily: 'Poppins'),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        labelText: labelText,
        labelStyle: hintStyle ??
            TextStyle(
              color: effectiveTextColor.withOpacity(0.5),
              fontFamily: 'Poppins',
            ),
        hintStyle: hintStyle ??
            TextStyle(
              color: Colors.black87.withOpacity(0.5),
              fontFamily: 'Poppins',
            ),        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: enabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: focusColor),
        ),
      ),
    );
  }
}