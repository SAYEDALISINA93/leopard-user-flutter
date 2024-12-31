import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class CustomCheckBox extends StatefulWidget {
  final List<String>? selectedValue;
  final List<String> list;
  final ValueChanged? onChanged;

  const CustomCheckBox({
    super.key,
    this.selectedValue,
    required this.list,
    this.onChanged,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        Column(
            children: List<CheckboxListTile>.generate(widget.list.length,
                (int index) {
          List<String>? s = widget.selectedValue;
          bool selected_ = s != null ? s.contains(widget.list[index]) : false;
          return CheckboxListTile(
            value: selected_,
            activeColor: MyColor.primaryColor,
            title: Text(
              widget.list[index].tr,
              style: regularDefault.copyWith(color: MyColor.colorBlack),
            ),
            onChanged: (bool? value) {
              setState(() {
                if (value != null) {
                  widget.onChanged!('${index}_$value');
                }
              });
            },
          );
        })),
      ],
    );
  }
}
