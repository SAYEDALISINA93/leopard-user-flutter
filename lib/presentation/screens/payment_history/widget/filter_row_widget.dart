import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/style.dart';

class FilterRowWidget extends StatefulWidget {

  final String text;
  final bool fromTrx;
  final Color iconColor;
  final Callback press;
  final bool isFilterBtn;
  final Color bgColor;

  const FilterRowWidget({
    super.key,
    this.bgColor = MyColor.containerBgColor,
    this.isFilterBtn=false,
    this.iconColor = MyColor.primaryColor,
    required this.text,
    required this.press,
    this.fromTrx=false
  });

  @override
  State<FilterRowWidget> createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:widget.press,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.isFilterBtn ? MyColor.primaryColor : widget.bgColor,
          border: Border.all(color: MyColor.colorGrey, width: widget.isFilterBtn ? 0 : 0.5)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            widget.fromTrx ? Expanded(child: Text(widget.text.tr,style: regularDefault.copyWith(overflow: TextOverflow.ellipsis,color: widget.isFilterBtn ? MyColor.colorBlack : MyColor.colorBlack))): Expanded(child: Text(widget.text.tr,style: regularDefault.copyWith(color:MyColor.colorBlack,overflow: TextOverflow.ellipsis),)),
            const SizedBox(width: 20,),
            Icon(Icons.expand_more,color: widget.iconColor,size: 17)
          ],
        ),
      ),
    );
  }
}
