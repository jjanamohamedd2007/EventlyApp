import 'package:evently_app/core/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/light_theme.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? imageField;

  const TextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.textInputType,
    required this.controller,
    required this.validator,
    required this.imageField,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool _obscureText = true;

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor =
    isDark ? AppColors.primary : LightTheme.textField.color!;
    final Color? textColor =
    isDark ? DarkTheme.textField.color : LightTheme.textField.color;
    final Color? hintColor =
    isDark ? DarkTheme.textField.color : LightTheme.textField.color;
    final Color? iconColor =
    isDark ? DarkTheme.textField.color : LightTheme.textField.color;
    final double? hintSize =
    isDark ? DarkTheme.textField.fontSize : LightTheme.textField.fontSize;

    final bool isPasswordField =
    widget.hintText.toLowerCase().contains("password");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 361,
            height: 70,
            child: TextFormField(
              controller: widget.controller,
              cursorColor: borderColor,
              keyboardType: widget.textInputType,
              validator: (value) {
                final result = widget.validator?.call(value);
                setState(() {
                  _errorText = result;
                });
                return result;
              },
              style: TextStyle(color: textColor,  fontSize: 16,),
              obscureText: isPasswordField ? _obscureText : false,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Image.asset(
                    widget.imageField!,
                    color: iconColor,
                    width: 22,
                    height: 22,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                suffixIcon: isPasswordField
                    ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: iconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                    : null,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(fontSize: hintSize, color: hintColor),
                errorStyle:
                const TextStyle(height: 0, fontSize: 0),
              ),
            ),
          ),

          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                _errorText!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
