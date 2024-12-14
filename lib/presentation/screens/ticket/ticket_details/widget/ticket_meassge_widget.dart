import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/support/ticket_details_controller.dart';
import 'package:leoparduser/data/model/support/support_ticket_view_response_model.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';

class TicketViewCommentReplyModel extends StatelessWidget {
  const TicketViewCommentReplyModel(
      {super.key, required this.index, required this.messages});

  final SupportMessage messages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketDetailsController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: messages.adminId == "1"
                ? MyColor.pendingColor.withOpacity(0.1)
                : MyColor.getCardBgColor(),
            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            border: Border.all(
                color: messages.adminId == "1"
                    ? MyColor.pendingColor
                    : MyColor.borderColor,
                strokeAlign: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: ClipOval(
                      child:
                          Image.asset(MyImages.profile, height: 45, width: 45)),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (messages.admin == null)
                          Text('${messages.ticket?.name}',
                              style: boldDefault.copyWith(
                                  color: MyColor.getTextColor()))
                        else
                          Text('${messages.admin?.name}',
                              style: boldDefault.copyWith(
                                  color: MyColor.getTextColor())),
                        Text(
                            messages.adminId == "1"
                                ? MyStrings.admin.tr
                                : MyStrings.you.tr,
                            style: boldDefault.copyWith()),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                        DateConverter.getFormatSubtractTime(
                            messages.createdAt ?? ''),
                        style: regularSmall.copyWith(color: MyColor.colorGrey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space10,
                        vertical: Dimensions.space5),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.cardRadius),
                    ),
                    child: Text(
                      messages.message ?? "",
                      style: regularDefault.copyWith(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (messages.attachments?.isNotEmpty ?? false)
              Container(
                height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space10,
                    vertical: Dimensions.space5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: messages.attachments != null
                        ? List.generate(
                            messages.attachments!.length,
                            (i) => controller.selectedIndex == i
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.space30,
                                        vertical: Dimensions.space10),
                                    decoration: BoxDecoration(
                                      color: MyColor.colorWhite,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.mediumRadius),
                                    ),
                                    child: const SpinKitThreeBounce(
                                        size: 20.0,
                                        color: MyColor.primaryColor),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      String url =
                                          '${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}';
                                      String ext = messages
                                              .attachments?[i].attachment!
                                              .split('.')[1] ??
                                          'pdf';
                                      if (MyUtils.isImage(messages
                                              .attachments?[i].attachment
                                              .toString() ??
                                          "")) {
                                        Get.toNamed(
                                          RouteHelper.previewImageScreen,
                                          arguments:
                                              "${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}",
                                        );
                                      } else {
                                        controller.downloadAttachment(
                                            url,
                                            messages.attachments?[i].id ?? -1,
                                            ext);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width >
                                              500
                                          ? 100
                                          : 100,
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  500
                                              ? 100
                                              : 100,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColor.borderColor),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.mediumRadius),
                                      ),
                                      child: MyUtils.isImage(messages
                                                  .attachments?[i].attachment
                                                  .toString() ??
                                              "")
                                          ? controller.selectedIndex == i
                                              ? const SizedBox(
                                                  height: 16,
                                                  width: 16,
                                                  child: CustomLoader(
                                                      isPagination: true))
                                              : MyImageWidget(
                                                  imageUrl:
                                                      "${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}",
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          500
                                                      ? 100
                                                      : 100,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          500
                                                      ? 100
                                                      : 100)
                                          : MyUtils.isXlsx(messages
                                                      .attachments?[i]
                                                      .attachment ??
                                                  "")
                                              ? Container(
                                                  width: context.width / 5,
                                                  height: context.width / 5,
                                                  decoration: BoxDecoration(
                                                      color: MyColor.colorWhite,
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .mediumRadius),
                                                      border: Border.all(
                                                          color: MyColor
                                                              .borderColor,
                                                          width: 1)),
                                                  child: Center(
                                                      child: controller
                                                                  .selectedIndex ==
                                                              i
                                                          ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child: CircularProgressIndicator(
                                                                  color: MyColor
                                                                      .primaryColor))
                                                          : SvgPicture.asset(
                                                              MyIcons.xlsx,
                                                              height: 45,
                                                              width: 45)),
                                                )
                                              : MyUtils.isDoc(messages.attachments?[i].attachment ?? "")
                                                  ? Container(
                                                      width: context.width / 5,
                                                      height: context.width / 5,
                                                      decoration: BoxDecoration(
                                                          color: MyColor
                                                              .colorWhite,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .mediumRadius),
                                                          border: Border.all(
                                                              color: MyColor
                                                                  .borderColor,
                                                              width: 1)),
                                                      child: Center(
                                                          child: controller
                                                                      .selectedIndex ==
                                                                  i
                                                              ? const SizedBox(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: CircularProgressIndicator(
                                                                      color: MyColor
                                                                          .primaryColor))
                                                              : SvgPicture
                                                                  .asset(
                                                                      MyIcons
                                                                          .doc,
                                                                      height:
                                                                          45,
                                                                      width:
                                                                          45)),
                                                    )
                                                  : Container(
                                                      width: context.width / 5,
                                                      height: context.width / 5,
                                                      decoration: BoxDecoration(
                                                          color: MyColor
                                                              .colorWhite,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .mediumRadius),
                                                          border: Border.all(
                                                              color: MyColor
                                                                  .borderColor,
                                                              width: 1)),
                                                      child: Center(
                                                          child: controller
                                                                      .selectedIndex ==
                                                                  i
                                                              ? const SizedBox(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: CircularProgressIndicator(
                                                                      color: MyColor
                                                                          .primaryColor))
                                                              : SvgPicture.asset(
                                                                  MyIcons
                                                                      .pdfFile,
                                                                  height: 45,
                                                                  width: 45)),
                                                    ),
                                    ),
                                  ),
                          )
                        : const [SizedBox.shrink()],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
