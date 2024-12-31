import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutLineTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  TextStyle? titleStyle;
  final TextInputAction inputAction;
  double? radius;
  final Color fillColor;
  Color? focusColor;

  OutLineTextField({
    super.key,
    this.labelText,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.titleStyle,
    this.inputAction = TextInputAction.next,
    this.radius = Dimensions.defaultRadius,
    this.fillColor = MyColor.transparentColor,
    this.focusColor,
  });

  @override
  State<OutLineTextField> createState() => _OutLineTextFieldState();
}

class _OutLineTextFieldState extends State<OutLineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: 1,
        style: widget.titleStyle ??
            regularDefault.copyWith(color: MyColor.getTextColor()),
        textAlign: TextAlign.left,
        cursorColor: MyColor.getTextColor(),
        controller: widget.controller,
        autofocus: false,
        textInputAction: widget.inputAction,
        focusNode: widget.focusNode,
        validator: widget.validator,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.only(
              top: 5, start: 15, end: 15, bottom: 5),
          labelText: widget.labelText?.tr ?? '',
          labelStyle:
              regularDefault.copyWith(color: MyColor.getLabelTextColor()),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: MyColor.getTextFieldDisableBorder()),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          fillColor: widget.fillColor,
          filled: true,
          hintText: widget.hintText?.tr ?? '',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: widget.focusColor ?? MyColor.getTextFieldEnableBorder(),
            ),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: MyColor.getTextFieldDisableBorder()),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
        )
        // onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
        // onChanged: (text) => widget.onChanged!(text),
        );
  }
}
