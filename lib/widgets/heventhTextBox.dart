import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';



class Txt extends StatelessWidget {
  void Function(String value)? onChanged;
  String? Function(String? value)? validator;
  bool isPasswordField;
  bool isEnabled;
  bool readOnly;
  String placeholderText;
  String initialValue;
  double width;
  double borderRadius;
  double height;
  int maxLength;
  int maxLine;
  TextStyle? textStyle;
  Icon? suffixIcon;
  TextEditingController? controller;
  TextInputType? keyboardType;
  void Function()? onSuffixItemTapped;
  EdgeInsetsGeometry? contentPadding;
  bool isNaira;

  Txt({
    this.validator,
    this.isPasswordField = false,
    this.isEnabled = true,
    this.placeholderText = "",
    this.initialValue = '',
    this.width = double.infinity,
    this.borderRadius=10,
    this.height = 20,
    this.textStyle,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLength = 80,
    this.maxLine = 1,
    this.onSuffixItemTapped,
    this.keyboardType,
    this.controller,
    this.contentPadding,
    required this.onChanged,
    this.isNaira = false,
  });

  @override
  Widget build(BuildContext context) {
    bool usesSuffixIcon = (suffixIcon != null);
    Screen screen=getScreen();
    return Container(
      width: (screen==Screen.tab)?width/1.4:width,
      child: TextFormField(
        enabled: isEnabled,
        onChanged:  onChanged,
        controller: controller,
        obscureText: isPasswordField,
        maxLines: maxLine,
        readOnly: readOnly,
        maxLength: maxLength,
        validator: validator,
        keyboardType: isNaira && keyboardType == null
            ? TextInputType.number
            : keyboardType,
        inputFormatters:(keyboardType==TextInputType.number)? [
          new FilteringTextInputFormatter.allow(
              RegExp("[0-9]")),
        ]:null,
        // initialValue: isNaira && initialValue.isEmpty ? null : initialValue,
        decoration: InputDecoration(
          hintText: placeholderText,
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          filled: true,
          fillColor: Color(0xFFC4C4C4).withOpacity(0.2),
          suffixIcon: usesSuffixIcon
              ? InkWell(
            onTap: onSuffixItemTapped,
            enableFeedback: true,
            child: suffixIcon,
          )
              : null,
          contentPadding: (contentPadding == null)
              ? EdgeInsets.symmetric(vertical: 3,horizontal: 10)
              : contentPadding,
        ),
        style: textStyle,
        // inputFormatters: isNaira ? [NairaFormatter()] : [],
      ),
    );
  }
}


class MyDropDown extends StatelessWidget {
  final Widget suffixIcon;
  final String hint;
  final String drop_value;
  final double width;
  void  Function(String? item)? onChanged;
  final List<DropdownMenuItem<String>> itemFunction;

  MyDropDown(
      {
        this.drop_value="",
        this.hint="",
        this.width=double.maxFinite,
        // required this.onChange,
        this.suffixIcon=const Text("show"),
        required  this.itemFunction,
        this.onChanged,
      });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: (screen==Screen.tab)?width/1.4:width,
      // margin: EdgeInsets.only(top: MySize.size16),
      child: DropdownButtonFormField<String>(
        value: drop_value,
        icon: Visibility(visible: true, child: Icon(Icons.keyboard_arrow_down)),
        style: TextStyle(
            color: Colors.black,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w600),

        decoration: InputDecoration(
            hintText: hint,
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Color(0xFFC4C4C4).withOpacity(0.2),
            contentPadding:  EdgeInsets.symmetric(vertical: 3,horizontal: 10)

        ),



        isExpanded: true,
        onChanged: onChanged,
        items: itemFunction,
      ),
    );
  }
}
