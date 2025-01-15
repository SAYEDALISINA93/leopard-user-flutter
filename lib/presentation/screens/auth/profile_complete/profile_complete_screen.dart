import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/controller/account/profile_complete_controller.dart';
import 'package:leoparduser/data/repo/account/profile_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:leoparduser/presentation/components/text/label_text.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';
import 'package:leoparduser/presentation/screens/auth/registration/widget/country_bottom_sheet.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  bool isNumberBlank = false;

  @override
  void initState() {
    // print("Profile Complete Screen");
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProfileRepo(
      apiClient: Get.find(),
    ));
    final controller =
        Get.put(ProfileCompleteController(profileRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: WillPopWidget(
        nextRoute: '',
        child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<ProfileCompleteController>(
            builder: (controller) => SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(MyImages.appLogoWhite,
                        width: MediaQuery.of(context).size.width / 3),
                    Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(MyIcons.bg,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: 200)),
                    Container(
                      padding: const EdgeInsetsDirectional.only(
                          top: Dimensions.space20,
                          bottom: Dimensions.space20,
                          start: Dimensions.space20,
                          end: Dimensions.space20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Dimensions.cardRadius)),
                      child: controller.isLoading
                          ? const CustomLoader()
                          : Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          MyStrings.profileCompleteTitle.tr,
                                          style: boldExtraLarge.copyWith(
                                              fontSize:
                                                  Dimensions.fontExtraLarge +
                                                      5))),
                                  const SizedBox(height: Dimensions.space5),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        MyStrings.profileCompleteSubTitle.tr
                                            .toTitleCase(),
                                        textAlign: TextAlign.center,
                                        style: regularDefault.copyWith(
                                            color: MyColor.getBodyTextColor(),
                                            fontSize: Dimensions.fontLarge)),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .04),
                                  // CustomTextField(
                                  //   animatedLabel: false,
                                  //   isRequired: true,
                                  //   needOutlineBorder: true,
                                  //   labelText: MyStrings.username.tr,
                                  //   hintText:
                                  //       "${MyStrings.enterYour.tr} ${MyStrings.username.toLowerCase().tr}",
                                  //   textInputType: TextInputType.text,
                                  //   inputAction: TextInputAction.next,
                                  //   focusNode: controller.userNameFocusNode,
                                  //   controller: controller.userNameController,
                                  //   nextFocus: controller.mobileNoFocusNode,
                                  //   onChanged: (value) {
                                  //     return;
                                  //   },
                                  //   validator: (value) {
                                  //     if (value != null && value.isEmpty) {
                                  //       return MyStrings.enterYourUsername.tr;
                                  //     } else if (value.length < 6) {
                                  //       return MyStrings.kShortUserNameError;
                                  //     } else {
                                  //       return null;
                                  //     }
                                  //   },
                                  // ),
                                  // const SizedBox(height: Dimensions.space20),
                                  // LabelText(
                                  //     text: MyStrings.country,
                                  //     isRequired: true),
                                  // const SizedBox(
                                  //     height: Dimensions.textToTextSpace),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: MyColor.colorWhite,
                                  //       border: Border.all(
                                  //           color: isNumberBlank
                                  //               ? MyColor.colorRed
                                  //               : MyColor.primaryColor
                                  //                   .withOpacity(0.08)),
                                  //       borderRadius: BorderRadius.circular(
                                  //           Dimensions.mediumRadius)),
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: Dimensions.space10),
                                  //   child: Row(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           CountryBottomSheet
                                  //               .profileBottomSheet(
                                  //                   context, controller);
                                  //         },
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.center,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             MyImageWidget(
                                  //               imageUrl: UrlContainer
                                  //                   .countryFlagImageLink
                                  //                   .replaceAll(
                                  //                       "{countryCode}",
                                  //                       controller
                                  //                           .selectedCountryData
                                  //                           .countryCode
                                  //                           .toString()
                                  //                           .toLowerCase()),
                                  //               height: Dimensions.space25,
                                  //               width: Dimensions.space40,
                                  //             ),
                                  //             spaceSide(Dimensions.space3),
                                  //             Icon(
                                  //                 Icons
                                  //                     .keyboard_arrow_down_rounded,
                                  //                 color: MyColor
                                  //                     .getBodyTextColor()),
                                  //             spaceSide(Dimensions.space5),
                                  //             Container(
                                  //                 color: MyColor
                                  //                     .getBodyTextColor(),
                                  //                 width: 1,
                                  //                 height: Dimensions.space15),
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsetsDirectional
                                  //                       .only(
                                  //                       start:
                                  //                           Dimensions.space10),
                                  //               child: Text(
                                  //                   "+${controller.selectedCountryData.dialCode}",
                                  //                   style: regularMediumLarge
                                  //                       .copyWith(
                                  //                           fontSize: Dimensions
                                  //                               .fontOverLarge)),
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Padding(
                                  //           padding: const EdgeInsetsDirectional
                                  //               .only(
                                  //               start: Dimensions.space5,
                                  //               top: Dimensions.space5 - 1),
                                  //           child: TextFormField(
                                  //             decoration: InputDecoration(
                                  //               suffixIcon: Padding(
                                  //                 padding: const EdgeInsets.all(
                                  //                     Dimensions.space15),
                                  //                 child: MyLocalImageWidget(
                                  //                     imagePath: MyIcons.phone,
                                  //                     height: 15,
                                  //                     imageOverlayColor: MyColor
                                  //                         .getBodyTextColor()),
                                  //               ),
                                  //               border: InputBorder
                                  //                   .none, // Remove border
                                  //               filled: false, // Remove fill
                                  //               contentPadding:
                                  //                   const EdgeInsetsDirectional
                                  //                       .only(
                                  //                       top: 6.7,
                                  //                       start: 0,
                                  //                       end: 15,
                                  //                       bottom: 0),
                                  //               hintStyle:
                                  //                   regularMediumLarge.copyWith(
                                  //                       fontSize: Dimensions
                                  //                           .fontOverLarge,
                                  //                       color: MyColor
                                  //                           .getBodyTextColor()),
                                  //               hintText: MyStrings
                                  //                   .enterPhoneNumber000.tr,
                                  //             ),
                                  //             controller:
                                  //                 controller.mobileNoController,
                                  //             keyboardType: TextInputType
                                  //                 .phone, // Set keyboard type to phone
                                  //             style:
                                  //                 regularMediumLarge.copyWith(
                                  //                     fontSize: Dimensions
                                  //                         .fontOverLarge),
                                  //             cursorColor: MyColor
                                  //                 .primaryColor, // Set cursor color to red
                                  //             onChanged: (value) {
                                  //               controller.mobileNoController
                                  //                       .text.isNotEmpty
                                  //                   ? isNumberBlank = false
                                  //                   : null;
                                  //               setState(() {});
                                  //             },
                                  //             focusNode:
                                  //                 controller.mobileNoFocusNode,
                                  //             validator: (value) {
                                  //               final whitespaceOrEmpty =
                                  //                   RegExp(r"^\s*$|^$");
                                  //               if (whitespaceOrEmpty
                                  //                   .hasMatch(value ?? "")) {
                                  //                 setState(() {
                                  //                   isNumberBlank = true;
                                  //                 });
                                  //                 return;
                                  //               } else {
                                  //                 return null;
                                  //               }
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // isNumberBlank
                                  //     ? const SizedBox(
                                  //         height: Dimensions.space5)
                                  //     : const SizedBox.shrink(),
                                  // isNumberBlank
                                  //     ? Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(left: 8.0),
                                  //         child: Text(
                                  //             MyStrings.enterYourPhoneNumber,
                                  //             style: regularSmall.copyWith(
                                  //                 color: MyColor.colorRed)))
                                  //     : const SizedBox.shrink(),
                                  const SizedBox(height: Dimensions.space20),
                                  CustomTextField(
                                    animatedLabel: false,
                                    isRequired: true,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.firstName.tr,
                                    hintText:
                                        "${MyStrings.enterYour.tr} ${MyStrings.firstName.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.firstNameFocusNode,
                                    controller: controller.firstNameController,
                                    nextFocus: controller.lastNameFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return MyStrings.kFirstNameNullError.tr;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space20),
                                  CustomTextField(
                                    animatedLabel: false,
                                    isRequired: true,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.lastName.tr,
                                    hintText:
                                        "${MyStrings.enterYour.tr} ${MyStrings.lastName.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.lastNameFocusNode,
                                    controller: controller.lastNameController,
                                    nextFocus: controller.addressFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return MyStrings.kLastNameNullError.tr;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space20),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.address,
                                    hintText:
                                        "${MyStrings.enterYour.tr} ${MyStrings.address.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.addressFocusNode,
                                    controller: controller.addressController,
                                    nextFocus: controller.stateFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space20),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.state,
                                    hintText:
                                        "${MyStrings.enterYour.tr} ${MyStrings.state.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.stateFocusNode,
                                    controller: controller.stateController,
                                    nextFocus: controller.cityFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space20),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.city.tr,
                                    hintText:
                                        "${MyStrings.enterYour.tr} ${MyStrings.city.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.cityFocusNode,
                                    controller: controller.cityController,
                                    nextFocus: controller.zipCodeFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space20),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.zipCode.tr,
                                    hintText:
                                        "${MyStrings.enterYour.tr} ${MyStrings.zipCode.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.done,
                                    focusNode: controller.zipCodeFocusNode,
                                    controller: controller.zipCodeController,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  if (controller.loginType == "google") ...[
                                    const SizedBox(height: Dimensions.space20),
                                    CustomTextField(
                                      animatedLabel: false,
                                      needOutlineBorder: true,
                                      labelText: MyStrings.referanceName,
                                      hintText: MyStrings.referanceName.tr,
                                      textInputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      controller: controller.referController,
                                      nextFocus: controller.addressFocusNode,
                                      onChanged: (value) {
                                        return;
                                      },
                                    ),
                                  ],
                                  const SizedBox(height: Dimensions.space35),
                                  RoundedButton(
                                    isLoading: controller.submitLoading,
                                    text: MyStrings.completeProfile.tr,
                                    press: () {
                                      if (formKey.currentState!.validate()) {
                                        controller.updateProfile();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
