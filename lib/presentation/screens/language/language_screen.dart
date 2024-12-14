import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/localization/localization_controller.dart';
import 'package:leoparduser/data/controller/my_language_controller/my_language_controller.dart';
import 'package:leoparduser/data/repo/auth/general_setting_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/screens/language/widget/language_card.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(LocalizationController(sharedPreferences: Get.find()));
    final controller = Get.put(MyLanguageController(
        repo: Get.find(), localizationController: Get.find()));

    comeFrom = Get.arguments ?? '';

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    printx(MyStrings.language);
    printx(MyStrings.language.tr);
    return GetBuilder<MyLanguageController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          isShowBackBtn: true,
          title: MyStrings.language.tr,
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : controller.langList.isEmpty
                ? const NoDataWidget()
                : SingleChildScrollView(
                    padding: Dimensions.screenPaddingHV,
                    child: ListView.builder(
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.langList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          controller.changeSelectedIndex(index);
                        },
                        child: LanguageCard(
                          index: index,
                          selectedIndex: controller.selectedIndex,
                          langName: controller.langList[index].languageName,
                          flag:
                              '${controller.languageImagePath}/${controller.langList[index].imageUrl}',
                        ),
                      ),
                    ),
                  ),
        bottomNavigationBar: controller.langList.isEmpty
            ? SizedBox.shrink()
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: Dimensions.space15,
                        horizontal: Dimensions.space15),
                    child: SizedBox(
                      height: 60,
                      child: RoundedButton(
                        text: MyStrings.confirm.tr,
                        isLoading: controller.isChangeLangLoading,
                        press: () {
                          controller.changeLanguage(controller.selectedIndex,
                              isComeFromSplashScreen: comeFrom.isNotEmpty);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
