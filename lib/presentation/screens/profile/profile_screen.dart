import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/account/profile_controller.dart';
import 'package:leoparduser/data/repo/account/profile_repo.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';

import '../../components/card/app_body_card.dart';
import '../../components/divider/custom_divider.dart';
import '../../components/image/my_network_image_widget.dart';
import 'widget/card_column.dart';
import 'widget/profile_view_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(ProfileController(profileRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          child: Scaffold(
            backgroundColor: MyColor.screenBgColor,
            appBar: CustomAppBar(
              title: MyStrings.profile.tr,
              bgColor: MyColor.getAppBarColor(),
            ),
            body: controller.isLoading
                ? const CustomLoader()
                : SingleChildScrollView(
                    padding: Dimensions.screenPaddingHV,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: double.infinity,
                      // color: Colors.orange,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Details Section
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  top: Dimensions.space50,
                                ),
                                child: AppBodyWidgetCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      spaceDown(Dimensions.space50),
                                      // ProfileCardColumn(
                                      //   header:
                                      //       MyStrings.username.tr.toUpperCase(),
                                      //   body: controller
                                      //           .model.data?.user?.username
                                      //           ?.toUpperCase() ??
                                      //       "",
                                      // ),
                                      CustomDivider(
                                        space: Dimensions.space15,
                                        color: MyColor.primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      ProfileCardColumn(
                                        header:
                                            MyStrings.fullName.tr.toUpperCase(),
                                        body:
                                            '${controller.model.data?.user?.firstname ?? ''} ${controller.model.data?.user?.lastname ?? ''}'
                                                .toTitleCase(),
                                      ),
                                      CustomDivider(
                                        space: Dimensions.space15,
                                        color: MyColor.primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      ProfileCardColumn(
                                        header:
                                            MyStrings.email.tr.toUpperCase(),
                                        body: controller.model.data?.user?.email
                                                ?.toLowerCase() ??
                                            "",
                                      ),
                                      CustomDivider(
                                        space: Dimensions.space15,
                                        color: MyColor.primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      ProfileCardColumn(
                                        header:
                                            MyStrings.phone.tr.toUpperCase(),
                                        body: controller
                                                .model.data?.user?.mobile
                                                ?.toLowerCase() ??
                                            "",
                                      ),
                                      CustomDivider(
                                        space: Dimensions.space15,
                                        color: MyColor.primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      ProfileCardColumn(
                                        header:
                                            MyStrings.country.tr.toUpperCase(),
                                        body: controller
                                                .model.data?.user?.country
                                                ?.toTitleCase() ??
                                            "",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                left: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: MyColor.screenBgColor,
                                        width: Dimensions.mediumRadius,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    height: Dimensions.space50 + 60,
                                    width: Dimensions.space50 + 60,
                                    child: ClipOval(
                                      child: MyImageWidget(
                                        imageUrl: controller.imageUrl,
                                        boxFit: BoxFit.cover,
                                        height: Dimensions.space50 + 60,
                                        width: Dimensions.space50 + 60,
                                        isProfile: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: const ProfileViewBottomNavBar(),
          ),
        );
      },
    );
  }
}
