import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class CustomRadioButton extends StatefulWidget {
  final String? title;
  final String? selectedValue;
  final int selectedIndex;
  final List<String> list;
  final ValueChanged? onChanged;

  const CustomRadioButton(
      {super.key,
      this.title,
      this.selectedIndex = 0,
      this.selectedValue,
      required this.list,
      this.onChanged});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        widget.title != null ? const SizedBox() : Text(widget.title ?? ''),
        Column(
            children: List<RadioListTile<int>>.generate(widget.list.length,
                (int index) {
          return RadioListTile<int>(
            value: index,
            groupValue: widget.selectedIndex,
            activeColor: MyColor.primaryColor,
            title: Text(
              widget.list[index].tr,
              style: regularDefault.copyWith(color: MyColor.colorBlack),
            ),
            selected: index == widget.selectedIndex,
            onChanged: (int? value) {
              setState(() {
                if (value != null) {
                  widget.onChanged!(index);
                }
              });
            },
          );
        })),
      ],
    );
  }
}
