import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:get/get.dart';

class SearchTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;

  const SearchTextField({
    super.key,
    this.labelText,
    this.readOnly = false,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.isSearch = false,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return widget.needOutlineBorder
        ? TextFormField(
            readOnly: widget.readOnly,
            style: regularDefault.copyWith(color: MyColor.getTextColor()),
            textAlign: TextAlign.left,
            cursorColor: MyColor.getTextColor(),
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
              hintText: widget.hintText,
              hintStyle:
                  regularSmall.copyWith(color: MyColor.getHintTextColor()),
              fillColor: MyColor.transparentColor,
              filled: true,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.getTextFieldDisableBorder()),
                  borderRadius:
                      BorderRadius.circular(Dimensions.defaultRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.getTextFieldEnableBorder()),
                  borderRadius:
                      BorderRadius.circular(Dimensions.defaultRadius)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.getTextFieldDisableBorder()),
                  borderRadius:
                      BorderRadius.circular(Dimensions.defaultRadius)),
              suffixIcon: widget.isShowSuffixIcon
                  ? widget.isPassword
                      ? IconButton(
                          icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: MyColor.hintTextColor,
                              size: 20),
                          onPressed: _toggle)
                      : widget.isIcon
                          ? IconButton(
                              onPressed: widget.onSuffixTap,
                              icon: Icon(
                                widget.isSearch
                                    ? Icons.search_outlined
                                    : widget.isCountryPicker
                                        ? Icons.arrow_drop_down_outlined
                                        : Icons.camera_alt_outlined,
                                size: 25,
                                color: MyColor.getPrimaryColor(),
                              ),
                            )
                          : null
                  : null,
            ),
            onFieldSubmitted: (text) => widget.nextFocus != null
                ? FocusScope.of(context).requestFocus(widget.nextFocus)
                : null,
            onChanged: (text) => widget.onChanged!(text),
          )
        : TextFormField(
            readOnly: widget.readOnly,
            style: regularDefault.copyWith(color: MyColor.getTextColor()),
            textAlign: TextAlign.left,
            cursorColor: MyColor.getHintTextColor(),
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 5),
              labelText: widget.labelText?.tr ?? '',
              labelStyle:
                  regularDefault.copyWith(color: MyColor.getLabelTextColor()),
              fillColor: MyColor.transparentColor,
              filled: true,
              border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.getTextFieldDisableBorder())),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.getTextFieldEnableBorder())),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.getTextFieldDisableBorder())),
              suffixIcon: widget.isShowSuffixIcon
                  ? widget.isPassword
                      ? IconButton(
                          icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: MyColor.hintTextColor,
                              size: 20),
                          onPressed: _toggle)
                      : widget.isIcon
                          ? IconButton(
                              onPressed: widget.onSuffixTap,
                              icon: Icon(
                                widget.isSearch
                                    ? Icons.search_outlined
                                    : widget.isCountryPicker
                                        ? Icons.arrow_drop_down_outlined
                                        : Icons.camera_alt_outlined,
                                size: 25,
                                color: MyColor.getPrimaryColor(),
                              ),
                            )
                          : null
                  : null,
            ),
            onFieldSubmitted: (text) => widget.nextFocus != null
                ? FocusScope.of(context).requestFocus(widget.nextFocus)
                : null,
            onChanged: (text) => widget.onChanged!(text),
          );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
