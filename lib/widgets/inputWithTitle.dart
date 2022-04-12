import 'package:flutter/material.dart';
const EdgeInsets defaultContainerPadding = EdgeInsets.only(bottom: 5, left: 5);

class InputWithTitle extends StatelessWidget {
  Widget inputWidget;
  String fieldLabel;
  TextStyle? titleStyle;
  EdgeInsets containerPadding;

  InputWithTitle({
    this.titleStyle,
    this.containerPadding = defaultContainerPadding,
    required this.fieldLabel,
    required this.inputWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: containerPadding,
          child: Text(fieldLabel, style: titleStyle),
        ),
        inputWidget

      ],
    );
  }
}
