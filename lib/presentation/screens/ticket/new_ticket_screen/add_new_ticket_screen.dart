import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/support/new_ticket_controller.dart';
import 'package:leoparduser/data/repo/support/support_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:leoparduser/presentation/components/text/label_text.dart';
import 'package:leoparduser/presentation/screens/ticket/ticket_details/widget/attachment_preview.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AddNewTicketScreen extends StatefulWidget {
  const AddNewTicketScreen({super.key});

  @override
  State<AddNewTicketScreen> createState() => _AddNewTicketScreenState();
}

class _AddNewTicketScreenState extends State<AddNewTicketScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportRepo(apiClient: Get.find()));
    Get.put(NewTicketController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewTicketController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.colorWhite,
        appBar:
            CustomAppBar(title: MyStrings.addNewTicket.tr, isTitleCenter: true),
        body: controller.isLoading
            ? const CustomLoader(isFullScreen: true)
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.textToTextSpace),
                      CustomTextField(
                        labelText: MyStrings.subject,
                        hintText: MyStrings.enterYourSubject.tr,
                        controller: controller.subjectController,
                        isPassword: false,
                        isShowSuffixIcon: false,
                        needOutlineBorder: true,
                        nextFocus: controller.messageFocusNode,
                        onSuffixTap: () {},
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      LabelText(text: MyStrings.priority.tr),
                      const SizedBox(height: Dimensions.space5),
                      DropDownTextFieldContainer(
                        color: MyColor.colorWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: DropdownButton<String>(
                            dropdownColor: MyColor.colorWhite,
                            value: controller.selectedPriority,
                            elevation: 8,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconDisabledColor: Colors.grey,
                            iconEnabledColor: MyColor.primaryColor,
                            isExpanded: true,
                            underline: Container(
                                height: 0, color: Colors.deepPurpleAccent),
                            onChanged: (String? newValue) {
                              controller.setPriority(newValue);
                            },
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.space2),
                            borderRadius: BorderRadius.circular(0),
                            items: controller.priorityList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: regularDefault.copyWith(
                                        fontSize: Dimensions.fontDefault)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      CustomTextField(
                        labelText: MyStrings.message,
                        hintText: MyStrings.enterYourMessage.tr,
                        isPassword: false,
                        needOutlineBorder: true,
                        controller: controller.messageController,
                        maxLines: 5,
                        focusNode: controller.messageFocusNode,
                        isShowSuffixIcon: false,
                        onSuffixTap: () {},
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      ZoomTapAnimation(
                        onTap: () {
                          if (controller.attachmentList.length < 5) {
                            controller.pickFile();
                          } else {
                            CustomSnackBar.error(
                                errorList: [MyStrings.maxAttachmentError]);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space20,
                              vertical: Dimensions.space30),
                          margin: const EdgeInsets.only(top: Dimensions.space5),
                          width: context.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyColor.borderColor, width: .5),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.mediumRadius),
                              color: MyColor.colorWhite),
                          child: Column(
                            children: [
                              const Icon(Icons.attachment_rounded,
                                  color: MyColor.colorGrey),
                              Text(MyStrings.chooseFile.tr,
                                  style: lightDefault.copyWith(
                                      color: MyColor.colorGrey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space5 - 3),
                      Text(MyStrings.supportedFileHint,
                          style: regularDefault.copyWith(
                              color: MyColor.highPriorityPurpleColor)),
                      const SizedBox(height: Dimensions.space10),
                      if (controller.attachmentList.isNotEmpty) ...[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              controller.attachmentList.length,
                              (index) => AttachmentPreviewWidget(
                                path: controller.attachmentList[index].path,
                                onTap: () =>
                                    controller.removeAttachmentFromList(index),
                                file: controller.attachmentList[index],
                                isShowCloseButton: true,
                                isFileImg: MyUtils.isImage(
                                    controller.attachmentList[index].path),
                              ),
                            ),
                          ),
                        )
                      ],
                      const SizedBox(height: 30),
                      Center(
                        child: RoundedButton(
                          isLoading: controller.submitLoading,
                          text: MyStrings.submit.tr,
                          press: () {
                            controller.submit();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class DropDownTextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const DropDownTextFieldContainer(
      {super.key, required this.child, this.color = MyColor.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          border: Border.all(
              color: Colors.black.withValues(alpha: 0.3), width: .5)),
      child: child,
    );
  }
}
