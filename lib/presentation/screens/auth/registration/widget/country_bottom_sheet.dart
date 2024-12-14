import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/controller/account/profile_complete_controller.dart';
import 'package:leoparduser/data/controller/auth/auth/registration_controller.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';

class CountryBottomSheet {
  static void bottomSheet(
      BuildContext context, RegistrationController controller) {
    CustomBottomSheet(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          if (controller.filteredCountries.isEmpty) {
            controller.filteredCountries = controller.countryList;
          }
          // Function to filter countries based on the search input.
          void filterCountries(String query) {
            if (query.isEmpty) {
              controller.filteredCountries = controller.countryList;
            } else {
              setState(() {
                controller.filteredCountries = controller.countryList
                    .where((country) => country.country!
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              });
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height * .8,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor.getCardBgColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const BottomSheetHeaderRow(header: '', bottomSpace: 15),
                const SizedBox(
                  height: 15,
                ),
                // Add the search field.
                TextField(
                  controller: controller.searchController,
                  onChanged: filterCountries,
                  decoration: InputDecoration(
                    hintText: MyStrings.searchCountry.tr,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  cursorColor: MyColor.primaryColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: ListView.builder(
                      itemCount: controller.filteredCountries.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var countryItem = controller.filteredCountries[index];

                        return GestureDetector(
                          onTap: () {
                            controller.setCountryNameAndCode(
                              controller.filteredCountries[index].country
                                  .toString(),
                              controller.filteredCountries[index].countryCode
                                  .toString(),
                              controller.filteredCountries[index].dialCode
                                  .toString(),
                            );
                            // controller.updateMobilecode(controller.filteredCountries[index].dialCode.toString());
                            controller.selectCountryData(
                                controller.filteredCountries[index]);
                            Navigator.pop(context);
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            controller.mobileFocusNode.nextFocus();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: MyColor.transparentColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: MyColor.colorGrey.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      end: Dimensions.space10),
                                  child: MyImageWidget(
                                    imageUrl: UrlContainer.countryFlagImageLink
                                        .replaceAll(
                                            "{countryCode}",
                                            countryItem.countryCode
                                                .toString()
                                                .toLowerCase()),
                                    height: Dimensions.space25,
                                    width: Dimensions.space40 + 2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      end: Dimensions.space10),
                                  child: Text(
                                    '+${countryItem.dialCode}',
                                    style: regularDefault.copyWith(
                                        color: MyColor.getTextColor()),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${countryItem.country}',
                                    style: regularDefault.copyWith(
                                        color: MyColor.getTextColor()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        },
      ),
    ).customBottomSheet(context);
  }

  static void profileBottomSheet(
      BuildContext context, ProfileCompleteController controller) {
    CustomBottomSheet(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          if (controller.filteredCountries.isEmpty) {
            controller.filteredCountries = controller.countryList;
          }
          // Function to filter countries based on the search input.
          void filterCountries(String query) {
            if (query.isEmpty) {
              controller.filteredCountries = controller.countryList;
            } else {
              setState(() {
                controller.filteredCountries = controller.countryList
                    .where((country) => country.country!
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              });
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height * .8,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor.getCardBgColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const BottomSheetHeaderRow(header: '', bottomSpace: 15),
                const SizedBox(
                  height: 15,
                ),
                // Add the search field.
                TextField(
                  controller: controller.searchController,
                  onChanged: filterCountries,
                  decoration: InputDecoration(
                    hintText: MyStrings.searchCountry.tr,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  cursorColor: MyColor.primaryColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: ListView.builder(
                      itemCount: controller.filteredCountries.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var countryItem = controller.filteredCountries[index];

                        return GestureDetector(
                          onTap: () {
                            // controller.updateMobilecode(controller.filteredCountries[index].dialCode.toString());
                            controller.selectCountryData(
                                controller.filteredCountries[index]);
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: MyColor.transparentColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: MyColor.colorGrey.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      end: Dimensions.space10),
                                  child: MyImageWidget(
                                    imageUrl: UrlContainer.countryFlagImageLink
                                        .replaceAll(
                                            "{countryCode}",
                                            countryItem.countryCode
                                                .toString()
                                                .toLowerCase()),
                                    height: Dimensions.space25,
                                    width: Dimensions.space40 + 2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      end: Dimensions.space10),
                                  child: Text(
                                    '+${countryItem.dialCode}',
                                    style: regularDefault.copyWith(
                                        color: MyColor.getTextColor()),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${countryItem.country}',
                                    style: regularDefault.copyWith(
                                        color: MyColor.getTextColor()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        },
      ),
    ).customBottomSheet(context);
  }
}
