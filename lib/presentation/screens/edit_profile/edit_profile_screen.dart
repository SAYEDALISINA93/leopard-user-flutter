import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/account/profile_controller.dart';
import 'package:leoparduser/data/repo/account/profile_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import '../../../core/utils/style.dart';
import '../../components/buttons/rounded_button.dart';
import '../../components/card/app_body_card.dart';
import '../../components/divider/custom_spacer.dart';
import '../../components/image/my_network_image_widget.dart';
import '../../components/text-form-field/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          isShowBackBtn: true,
          bgColor: MyColor.getAppBarColor(),
          title: MyStrings.editProfile.tr,
        ),
        body: SingleChildScrollView(
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
                // Edit Details Section
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: Dimensions.space50),
                      child: AppBodyWidgetCard(
                        child: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spaceDown(Dimensions.space50 + 10),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                isRequired: true,
                                controller: controller.firstNameController,
                                labelText: MyStrings.firstName.tr,
                                onChanged: (value) {},
                                readOnly: true,
                                fillColor: MyColor.colorGrey.withOpacity(0.1),
                                focusNode: controller.firstNameFocusNode,
                                nextFocus: controller.lastNameFocusNode,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                isRequired: true,
                                animatedLabel: false,
                                needOutlineBorder: true,
                                controller: controller.lastNameController,
                                labelText: MyStrings.lastName.tr,
                                onChanged: (value) {},
                                readOnly: true,
                                fillColor: MyColor.colorGrey.withOpacity(0.1),
                                focusNode: controller.lastNameFocusNode,
                                nextFocus: controller.emailFocusNode,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                controller: controller.emailController,
                                labelText: MyStrings.email.tr,
                                onChanged: (value) {},
                                focusNode: controller.emailFocusNode,
                                readOnly: true,
                                fillColor: MyColor.colorGrey.withOpacity(0.1),
                                textInputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                controller: controller.mobileNoController,
                                labelText: MyStrings.phone.tr,
                                onChanged: (value) {},
                                focusNode: controller.mobileNoFocusNode,
                                readOnly: true,
                                fillColor: MyColor.colorGrey.withOpacity(0.1),
                                textInputType: TextInputType.phone,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                controller: controller.addressController,
                                labelText: MyStrings.address.tr,
                                hintText: MyStrings.address,
                                onChanged: (value) {},
                                focusNode: controller.addressFocusNode,
                                nextFocus: controller.cityFocusNode,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                hintText: MyStrings.city,
                                controller: controller.cityController,
                                labelText: MyStrings.city.tr,
                                onChanged: (value) {},
                                focusNode: controller.cityFocusNode,
                                nextFocus: controller.stateFocusNode,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                controller: controller.stateController,
                                labelText: MyStrings.state.tr,
                                hintText: MyStrings.state,
                                onChanged: (value) {},
                                focusNode: controller.stateFocusNode,
                                nextFocus: controller.zipCodeFocusNode,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space20),
                              CustomTextField(
                                animatedLabel: false,
                                needOutlineBorder: true,
                                controller: controller.zipCodeController,
                                hintText: MyStrings.zipCode,
                                labelText: MyStrings.zipCode.tr,
                                onChanged: (value) {},
                                focusNode: controller.zipCodeFocusNode,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return MyStrings.fieldErrorMsg.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              spaceDown(Dimensions.space40),
                              RoundedButton(
                                horizontalPadding: Dimensions.space10,
                                verticalPadding: Dimensions.space15,
                                text: MyStrings.updateProfile,
                                textStyle: boldExtraLarge.copyWith(
                                    color: MyColor.colorWhite),
                                press: () {
                                  controller.updateProfile();
                                },
                                isLoading: controller.isSubmitLoading,
                                isOutlined: false,
                                color: MyColor.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyColor.screenBgColor,
                                      width: Dimensions.mediumRadius),
                                  shape: BoxShape.circle),
                              height: Dimensions.space50 + 60,
                              width: Dimensions.space50 + 60,
                              child: ClipOval(
                                child: controller.imageFile == null
                                    ? MyImageWidget(
                                        imageUrl: controller.imageUrl,
                                        boxFit: BoxFit.cover,
                                        height: Dimensions.space50 + 60,
                                        isProfile: true,
                                        width: Dimensions.space50 + 60)
                                    : Image.file(controller.imageFile!),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.openGallery(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: MyColor.simpleBg,
                                            border: Border.all(
                                                color: MyColor.colorWhite,
                                                width: Dimensions.space3),
                                            shape: BoxShape.circle),
                                        height: Dimensions.space40,
                                        width: Dimensions.space40,
                                        child: ClipOval(
                                          child: Icon(
                                            Icons.add_a_photo_outlined,
                                            size: Dimensions.space20,
                                            color: MyColor.getTextColor(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
