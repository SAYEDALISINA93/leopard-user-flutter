import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class FormRow extends StatelessWidget {
  final String label;
  final bool isRequired;

  const FormRow({super.key, required this.label, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label.tr,
            style: regularDefault.copyWith(color: MyColor.labelTextColor)),
        Text(isRequired ? ' *' : '',
            style: boldDefault.copyWith(color: Colors.red))
      ],
    );
  }
}
