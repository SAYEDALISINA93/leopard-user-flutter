import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:get/get.dart';

class CustomDropDownWithTextField extends StatefulWidget {
  final String? title, selectedValue;
  final List<String>? list;
  final ValueChanged? onChanged;

  const CustomDropDownWithTextField(
      {super.key, this.title, this.selectedValue, this.list, this.onChanged});

  @override
  State<CustomDropDownWithTextField> createState() =>
      _CustomDropDownWithTextFieldState();
}

class _CustomDropDownWithTextFieldState
    extends State<CustomDropDownWithTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.list?.removeWhere((element) => element.isEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: MyColor.transparentColor,
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.mediumRadius)),
            border: Border.all(color: MyColor.borderColor, width: .5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 5, top: 6, bottom: 6),
            child: DropdownButton(
              isExpanded: true,
              underline: Container(),
              hint: Text(
                widget.selectedValue?.tr ?? '',
                style: regularDefault.copyWith(color: MyColor.colorBlack),
              ), // Not necessary for Option 1
              value: widget.selectedValue,
              dropdownColor: MyColor.colorWhite,
              onChanged: widget.onChanged,
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
              items: widget.list!.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.tr,
                    style: regularDefault.copyWith(color: MyColor.colorBlack),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
