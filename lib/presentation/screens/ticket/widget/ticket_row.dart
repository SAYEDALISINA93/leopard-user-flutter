import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';

class TicketRow extends StatelessWidget {
  const TicketRow({
    super.key,
    required this.header,
    required this.value,
    this.isStatus = false,
    this.isPriority = false,
    this.isAction = false,
    this.isSubject = false,
    this.color = MyColor.colorGrey,
    this.borderColor = MyColor.borderColor,
    this.textColor,
  });

  final String header;
  final String value;
  final bool isStatus;
  final bool isPriority;
  final bool isAction;
  final bool isSubject;
  final Color color;
  final Color borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                header,
                style: regularDefault.copyWith(
                    color: textColor ?? MyColor.primaryColor),
              ),
            ),
            Flexible(
              child: isSubject
                  ? Text(
                      value,
                      style: regularDefault.copyWith(
                          color: textColor ?? MyColor.primaryColor),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                    )
                  : isPriority
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: textColor ??
                                  MyColor.primaryColor.withValues(alpha: 0.5),
                              border: Border.all(
                                  color: textColor ?? MyColor.borderColor),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.cardRadius)),
                          child: Text(
                            value,
                            style: regularDefault.copyWith(
                                color: MyColor.colorWhite),
                          ),
                        )
                      : isStatus
                          ? Text(value,
                              style: boldDefault.copyWith(color: textColor))
                          : Text(
                              value,
                              style: regularDefault.copyWith(
                                  color: MyColor.getTextColor()),
                            ),
            )
          ],
        ),
        isAction ? const SizedBox() : const SizedBox(height: 10),
        isAction
            ? const SizedBox()
            : const Divider(height: 2, color: MyColor.borderColor),
        isAction ? const SizedBox() : const SizedBox(height: 10)
      ],
    );
  }
}
