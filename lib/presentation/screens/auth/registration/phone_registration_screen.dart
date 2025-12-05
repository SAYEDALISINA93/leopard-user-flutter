import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/auth/phone_registration_controller.dart';
import 'package:leoparduser/data/repo/auth/general_setting_repo.dart';
import 'package:leoparduser/data/repo/auth/phone_signup_repo.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/custom_no_data_found_class.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';
import 'package:leoparduser/presentation/screens/auth/registration/widget/phone_registration_form.dart';
import 'package:leoparduser/presentation/screens/auth/social_auth/social_auth_section.dart';

import '../../../components/divider/custom_spacer.dart';

class PhoneRegistrationScreen extends StatefulWidget {
  const PhoneRegistrationScreen({super.key});

  @override
  State<PhoneRegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<PhoneRegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(PhoneRegistrationRepo(apiClient: Get.find()));
    Get.put(PhoneRegistrationController(
        registrationRepo: Get.find(), generalSettingRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PhoneRegistrationController>().initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: GetBuilder<PhoneRegistrationController>(
        builder: (controller) => WillPopWidget(
          nextRoute: RouteHelper.loginScreen,
          child: Scaffold(
            backgroundColor: MyColor.screenBgColor,
            body: controller.noInternet
                ? NoDataOrInternetScreen(
                    isNoInternet: true,
                    onChanged: () {
                      controller.initData();
                    },
                  )
                : controller.isLoading
                    ? CustomLoader()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: Dimensions.screenPaddingHV,
                        child: SafeArea(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(MyImages.appLogoWhite,
                                      width: MediaQuery.of(context).size.width /
                                          3),
                                  SvgPicture.asset(MyIcons.bg),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsetsDirectional.only(
                                  top: Dimensions.space10,
                                  bottom: Dimensions.space50 * 1,
                                ),
                                padding: const EdgeInsetsDirectional.only(
                                    top: Dimensions.space20,
                                    start: Dimensions.space20,
                                    end: Dimensions.space20,
                                    bottom: Dimensions.space20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.cardRadius)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    spaceDown(Dimensions.space20),
                                    Text(MyStrings.regScreenTitle.tr,
                                        style: boldExtraLarge.copyWith(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: Dimensions.space5),
                                    Text(
                                      MyStrings.regScreenSubTitle.tr,
                                      style: regularDefault.copyWith(
                                          color: MyColor.getBodyTextColor(),
                                          fontSize: 16),
                                    ),
                                    spaceDown(Dimensions.space20),
                                    SocialAuthSection(
                                        googleAuthTitle: MyStrings.regGoogle),
                                    spaceDown(Dimensions.space15),
                                    const PhoneRegistrationForm()
                                  ],
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
