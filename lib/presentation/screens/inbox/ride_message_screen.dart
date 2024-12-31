import 'dart:async';

import 'package:lottie/lottie.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_animation.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/map/ride_map_controller.dart';
import 'package:leoparduser/data/controller/pusher/pusher_ride_controller.dart';
import 'package:leoparduser/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:leoparduser/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:leoparduser/data/model/global/app/ride_meassage_model.dart';
import 'package:leoparduser/data/repo/meassage/meassage_repo.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_strings.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../packages/flutter_chat_bubble/chat_bubble.dart';

class RideMessageScreen extends StatefulWidget {
  String rideID;
  RideMessageScreen({super.key, required this.rideID});

  @override
  State<RideMessageScreen> createState() => _RideMessageScreenState();
}

class _RideMessageScreenState extends State<RideMessageScreen> {
  Timer? timer;

  @override
  void initState() {
    widget.rideID = Get.arguments;
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MessageRepo(apiClient: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    Get.put(RideMapController());
    Get.put(RideDetailsController(mapController: Get.find(), repo: Get.find()));
    final controller = Get.put(RideMessageController(repo: Get.find()));
    Get.put(PusherRideController(
        apiClient: Get.find(),
        controller: Get.find(),
        detailsController: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(Get.arguments);
    });
  }

  @override
  Widget build(BuildContext context) {
    getSenderView(CustomClipper clipper, BuildContext context, RideMessage item,
            imagePath) =>
        AnimatedContainer(
          duration: const Duration(microseconds: 500),
          curve: Curves.easeIn,
          child: ChatBubble(
            clipper: clipper,
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 5),
            backGroundColor: MyColor.primaryColor,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  item.image != "null"
                      ? InkWell(
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {
                            Get.toNamed(RouteHelper.previewImageScreen,
                                arguments: "$imagePath/${item.image}");
                          },
                          child: MyImageWidget(
                            imageUrl: "$imagePath/${item.image}",
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: Dimensions.space2),
                  Text('${item.message}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        );

    getReceiverView(CustomClipper clipper, BuildContext context,
            RideMessage item, String imagePath) =>
        AnimatedContainer(
          duration: const Duration(microseconds: 500),
          curve: Curves.easeIn,
          child: ChatBubble(
            clipper: clipper,
            backGroundColor: Colors.black54,
            margin: const EdgeInsets.only(top: 20),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.image != "null"
                      ? InkWell(
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {
                            Get.toNamed(RouteHelper.previewImageScreen,
                                arguments: "$imagePath/${item.image}");
                          },
                          child: MyImageWidget(
                            imageUrl: "$imagePath/${item.image}",
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: Dimensions.space2),
                  Text('${item.message}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        );

    ///
    return GetBuilder<RideMessageController>(
      builder: (controller) {
        return GetBuilder<PusherRideController>(builder: (pushController) {
          return Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: MyColor.screenBgColor,
            appBar: CustomAppBar(
              title: MyStrings.inbox,
              backBtnPress: () {
                Get.back();
              },
              actionsWidget: [
                IconButton(
                  onPressed: () {
                    controller.getRideMessage(controller.rideId,
                        p: 1, shouldLoading: false);
                  },
                  icon: const Icon(
                    Icons.refresh_outlined,
                    color: MyColor.colorWhite,
                  ),
                )
              ],
            ),
            body: pushController.isPusherLoading
                ? const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomLoader(),
                  )
                : controller.isLoading
                    ? const CustomLoader()
                    : controller.meassage.isEmpty
                        ? SizedBox(
                            height: context.height,
                            child: LottieBuilder.asset(
                              MyAnimation.emptyChat,
                              repeat: false,
                            ),
                          )
                        : ListView.builder(
                            controller: controller.scrollController,
                            padding: const EdgeInsetsDirectional.only(
                                start: Dimensions.space20,
                                end: Dimensions.space20,
                                bottom: Dimensions.space50 * 2),
                            itemCount: controller.meassage.length,
                            reverse: false,
                            itemBuilder: (c, index) {
                              var previous = index > 0
                                  ? controller.meassage[index - 1]
                                  : null;
                              var item = controller.meassage[index];
                              var next = index < controller.meassage.length - 1
                                  ? controller.meassage[index + 1]
                                  : null;
                              if (controller.hasNext()) {
                                return const SizedBox(
                                    child: CustomLoader(isPagination: true));
                              }
                              if (item.userId == controller.userId &&
                                  item.userId != "0") {
                                if (next?.userId == item.userId &&
                                    item.userId != "0") {
                                  printx(controller.meassage.last.toJson());
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        end: Dimensions.space6,
                                        top: previous?.driverId != item.driverId
                                            ? Dimensions.space15
                                            : Dimensions.space4),
                                    child: getSenderView(
                                        ChatBubbleClipper5(
                                            type: BubbleType.sendBubble,
                                            secondRadius: Dimensions.space50),
                                        context,
                                        item,
                                        controller.imagePath),
                                  );
                                } else {
                                  return getSenderView(
                                      ChatBubbleClipper3(
                                          type: BubbleType.sendBubble),
                                      context,
                                      item,
                                      controller.imagePath);
                                }
                              } else {
                                if (next?.userId == item.userId &&
                                    item.userId != "0") {
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: Dimensions.space6),
                                    child: getReceiverView(
                                        ChatBubbleClipper5(
                                            type: BubbleType.receiverBubble,
                                            secondRadius: Dimensions.space50),
                                        context,
                                        item,
                                        controller.imagePath),
                                  );
                                } else {
                                  return getReceiverView(
                                      ChatBubbleClipper3(
                                          type: BubbleType.receiverBubble),
                                      context,
                                      item,
                                      controller.imagePath);
                                }
                              }
                            }),
            bottomNavigationBar: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 50),
              child: Container(
                color: MyColor.transparentColor,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: Dimensions.space20,
                      right: Dimensions.space20,
                      bottom: Dimensions.space10,
                      top: Dimensions.space10),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(Dimensions.space12),
                  ),
                  height: Dimensions.space50 + 6,
                  child: Row(
                    children: [
                      Expanded(
                        child: controller.imageFile == null
                            ? GestureDetector(
                                onTap: () => controller.pickFile(),
                                child: Icon(Icons.image,
                                    color: MyColor.primaryColor))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius),
                                child: Image.file(controller.imageFile!,
                                    height: 35, width: 35),
                              ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsetsDirectional.only(
                              start: Dimensions.space30),
                          decoration: BoxDecoration(
                            color: MyColor.transparentColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: controller.meassageController,
                            cursorColor: MyColor.getPrimaryColor(),
                            style: regularSmall.copyWith(
                                color: MyColor.getTextColor()),
                            readOnly: false,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: MyStrings.writeYourMessage.tr,
                              hintStyle: mediumDefault.copyWith(
                                  color:
                                      MyColor.bodyTextColor.withOpacity(0.7)),
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                            onFieldSubmitted: (value) {
                              if (controller
                                      .meassageController.text.isNotEmpty &&
                                  controller.isSubmitLoading == false) {
                                controller.sendMessage();
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            end: Dimensions.space15),
                        child: InkWell(
                          onTap: () {
                            if (controller.meassageController.text.isNotEmpty &&
                                controller.isSubmitLoading == false) {
                              controller.sendMessage();
                            }
                          },
                          child: controller.isSubmitLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: MyColor.primaryColor,
                                  ),
                                )
                              : const MyLocalImageWidget(
                                  imagePath: MyIcons.sendArrow,
                                  width: Dimensions.space40,
                                  height: Dimensions.space40,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
