import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class LocationPickTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final VoidCallback? onTap;
  final TextInputAction inputAction;
  final Color fillColor;
  final VoidCallback? onSubmit;
  final double? radius;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? preffixIcon;

  const LocationPickTextField({
    super.key,
    this.labelText,
    this.fillColor = MyColor.transparentColor,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.textInputType,
    this.onTap,
    this.inputAction = TextInputAction.next,
    this.onSubmit,
    this.radius = Dimensions.mediumRadius,
    this.readOnly = false,
    this.suffixIcon,
    this.preffixIcon,
  });

  @override
  State<LocationPickTextField> createState() => _LocationPickTextFieldState();
}

class _LocationPickTextFieldState extends State<LocationPickTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: regularDefault.copyWith(
            color: MyColor.getTextColor(), fontSize: 16),
        readOnly: widget.readOnly,
        cursorColor: MyColor.getTextColor(),
        controller: widget.controller,
        autofocus: false,
        textInputAction: widget.inputAction,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.only(
              top: 5, start: 15, end: 15, bottom: 5),
          fillColor: widget.fillColor,
          filled: true,
          hintText: widget.hintText?.tr ?? '',
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.preffixIcon,
          prefixIconConstraints: BoxConstraints.loose(Size(40, 40)),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: MyColor.getTextFieldDisableBorder()),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: MyColor.getTextFieldEnableBorder(),
            ),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 0.5, color: MyColor.getTextFieldDisableBorder()),
              borderRadius: BorderRadius.circular(widget.radius!)),
        ),
        onChanged: (text) => widget.onChanged!(text),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        });
  }
}
