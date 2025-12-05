import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/app-bar/action_button_icon_widget.dart';
import 'package:leoparduser/presentation/components/dialog/exit_dialog.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isShowBackBtn;
  Widget? customBackBtn;
  final bool fromDashboard;
  final Color bgColor;
  final bool isShowActionBtn;
  final bool isTitleCenter;
  final bool fromAuth;
  final bool isProfileCompleted;
  final dynamic actionIcon;
  final VoidCallback? actionPress;
  final VoidCallback? backBtnPress;
  final bool isActionIconAlignEnd;
  final String actionText;
  final bool isActionImage;
  final double? elevation;
  final List<Widget>? actionsWidget;
  CustomAppBar({
    super.key,
    this.customBackBtn,
    this.isProfileCompleted = false,
    this.fromDashboard = false,
    this.fromAuth = false,
    this.isTitleCenter = false,
    this.bgColor = MyColor.primaryColor,
    this.isShowBackBtn = true,
    required this.title,
    this.isShowActionBtn = false,
    this.actionText = '',
    this.actionIcon,
    this.actionPress,
    this.backBtnPress,
    this.isActionIconAlignEnd = false,
    this.isActionImage = true,
    this.elevation = 0,
    this.actionsWidget,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool hasNotification = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShowBackBtn
        ? AppBar(
            elevation: widget.elevation,
            titleSpacing: 0,
            leading: widget.isShowBackBtn
                ? widget.customBackBtn ??
                    IconButton(
                      onPressed: () {
                        if (widget.backBtnPress != null) {
                          widget.backBtnPress!();
                        } else if (widget.fromAuth) {
                          Get.offAllNamed(RouteHelper.loginScreen);
                        } else if (widget.isProfileCompleted) {
                          showExitDialog(Get.context!);
                        } else {
                          // String previousRoute = Get.previousRoute;
                          // String currentRoute = Get.currentRoute;

                          Navigator.maybePop(context);
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: MyColor.getAppBarContentColor(),
                        size: 20,
                      ),
                    )
                : const SizedBox.shrink(),
            backgroundColor: widget.bgColor,
            title: Text(
              widget.title.tr,
              style:
                  boldDefault.copyWith(color: MyColor.getAppBarContentColor()),
            ),
            centerTitle: widget.isTitleCenter,
            actions: [
              ...?widget.actionsWidget,
              widget.isShowActionBtn
                  ? ActionButtonIconWidget(
                      pressed: widget.actionPress!,
                      isImage: widget.isActionImage,
                      icon: widget.isActionImage
                          ? Icons.add
                          : widget
                              .actionIcon, //just for demo purpose we put it here
                      imageSrc: widget.isActionImage ? widget.actionIcon : '',
                    )
                  : const SizedBox.shrink(),
              const SizedBox(width: 5),
            ],
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: widget.bgColor,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: MyColor.colorWhite,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            scrolledUnderElevation: 0,
            surfaceTintColor: MyColor.transparentColor,
          )
        : AppBar(
            titleSpacing: 0,
            elevation: widget.elevation,
            backgroundColor: widget.bgColor,
            title: Text(
              widget.title.tr,
              style:
                  boldDefault.copyWith(color: MyColor.getAppBarContentColor()),
            ),
            centerTitle: widget.isTitleCenter,
            actions: [
              ...?widget.actionsWidget,
              widget.isShowActionBtn
                  ? InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper.notificationScreen)
                            ?.then((value) {
                          setState(() {
                            hasNotification = false;
                          });
                        });
                      },
                      child: const SizedBox.shrink(),
                    )
                  : const SizedBox(),
            ],
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: widget.bgColor,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: MyColor.colorWhite,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            scrolledUnderElevation: 0,
            surfaceTintColor: MyColor.transparentColor,
          );
  }
}
