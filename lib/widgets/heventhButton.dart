import 'package:flutter/material.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';


class FillButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color fontColor;
  final Color enabledColor;
  final Color didsabledColor;
  final Color disabledButtonTextColor;
  final FontWeight fontWeight;
  final double fontSize;
  final bool enabled;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isBordered;
  final double borderRadius;
  final double activityIndicatorSize;
  final TextAlign? textAlignment;
  TextOverflow? overflow;
  int? maxLines;
  double activityIndicatorLineWidth;
  IconData? iconData;
  String imageIcon;

  FillButton(
      {
        this.width = double.maxFinite,
        this.height = 40,
        this.text = "Text",
        this.disabledButtonTextColor = AppTheme.heventhGrey,
        this.fontColor = Colors.white,
        this.fontWeight = FontWeight.w100,
        this.enabledColor = AppTheme.primaryColor,
        this.didsabledColor = AppTheme.heventhGrey,
        this.fontSize = 14,
        this.enabled = true,
        this.isBordered = false,
        this.borderRadius = 15,
        this.activityIndicatorSize = 20,
        this.activityIndicatorLineWidth = 3,
        this.iconData,
        this.maxLines = 1,
        this.textAlignment,
        this.overflow,
        this.imageIcon="",
        required this.onPressed,
        this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    Screen screen=getScreen();
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: enabled?enabledColor:didsabledColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        height: height,
        width: (screen==Screen.tab)?width/1.4:width,
        child: Center(child: Text(text,style: TextStyle(fontSize: fontSize,color: fontColor ),)),
      ),
    );
  }
}
