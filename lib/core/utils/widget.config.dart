import 'package:flutter/material.dart';

extension PaddingExtension on Map<String, dynamic> {
  EdgeInsetsDirectional toPadding() {
    return EdgeInsetsDirectional.only(
      start: double.tryParse(this['left']?.toString() ?? '0') ?? 0,
      end: double.tryParse(this['right']?.toString() ?? '0') ?? 0,
      top: double.tryParse(this['top']?.toString() ?? '0') ?? 0,
      bottom: double.tryParse(this['bottom']?.toString() ?? '0') ?? 0,
    );
  }

  EdgeInsetsDirectional toMargin() {
    return EdgeInsetsDirectional.only(
      start: double.tryParse(this['left']?.toString() ?? '0') ?? 0,
      end: double.tryParse(this['right']?.toString() ?? '0') ?? 0,
      top: double.tryParse(this['top']?.toString() ?? '0') ?? 0,
      bottom: double.tryParse(this['bottom']?.toString() ?? '0') ?? 0,
    );
  }

  BoxDecoration toDecoration() {
    return BoxDecoration(
      color: Color(int.parse(this['color']?.toString() ?? '0')),
      borderRadius: BorderRadius.circular(double.tryParse(this['borderRadius']?.toString() ?? '0') ?? 0),
      boxShadow: this['boxShadow']
          ?.map((e) => BoxShadow(color: Color(int.parse(e['color']?.toString() ?? '0')), offset: Offset(double.tryParse(e['offset']['width']?.toString() ?? '0') ?? 0, double.tryParse(e['offset']['height']?.toString() ?? '0') ?? 0), blurRadius: double.tryParse(e['blurRadius']?.toString() ?? '0') ?? 0, spreadRadius: double.tryParse(e['spreadRadius']?.toString() ?? '0') ?? 0))
          .toList(),
      border: Border.all(color: Color(int.parse(this['borderColor']?.toString() ?? '0')), width: double.tryParse(this['borderWidth']?.toString() ?? '0') ?? 0),
      //image: DecorationImage(image: NetworkImage(this['image']?.toString() ?? '')),
    );
  }
}
