// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

import '../commonfiles/appcolor.dart';

class TextFieldWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Color textFieldBorderColor;
  final TextInputType textInputType;
  final String hint;
  final Color hintColor;
  final Color textFieldTitleColor;
  final Color? textColor;
  final int? maxLines;
  final double? titleSize;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enable;
  final Function(String)? onchangevalue;

  const TextFieldWidget({
    required this.title,
    this.onchangevalue,
    required this.controller,
    required this.textFieldBorderColor,
    required this.textInputType,
    required this.hint,
    required this.hintColor,
    required this.textFieldTitleColor,
    this.textColor,
    this.maxLines,
    this.titleSize,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.enable = true,
  });

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Refresh the UI on focus change
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title.isNotEmpty
            ? Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.titleSize ?? 18,
                  fontWeight: FontWeight.w400,
                  color: widget.textFieldTitleColor,
                ),
              )
            : SizedBox.shrink(),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10),
          child: TextField(
            enabled: widget.enable,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.textInputType,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito Sans',
              color: widget.textColor ?? Colors.black,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFD5564), width: 1),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Nunito Sans',
                color: widget.hintColor,
              ),
              // contentPadding: EdgeInsets.fromLTRB(18, 15, 18, 15),
              alignLabelWithHint: true,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
            maxLines: widget.maxLines ?? 1,
            cursorHeight: 20,
            cursorColor:AppColor.tinderclr,
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
      ],
    );
  }
}

Widget TextWidget(
    {required String text,
    double fontSize = 16,
    required FontWeight fontWeight,
    required Color color,
    TextAlign? textAlign,
    FontStyle? fontStyle}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Nunito Sans',
        color: color,
        fontStyle: fontStyle),
    textAlign: textAlign ?? TextAlign.center,
  );
}

Widget SpaceWidget(
        {double? height, double? width, Color? color, Widget? child}) =>
    SizedBox(height: height, width: width, child: child);
