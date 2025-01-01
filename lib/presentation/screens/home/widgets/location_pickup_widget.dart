import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../../core/utils/util.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/text-form-field/location_pick_text_field.dart';
import '../../../components/text/header_text.dart';

class LocationPickUpHomeWidget extends StatefulWidget {
  final HomeController controller;
  const LocationPickUpHomeWidget({super.key, required this.controller});

  @override
  State<LocationPickUpHomeWidget> createState() =>
      _LocationPickUpHomeWidgetState();
}

class _LocationPickUpHomeWidgetState extends State<LocationPickUpHomeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyColor.getCardBgColor(),
          boxShadow: MyUtils.getCardShadow(),
          borderRadius: BorderRadius.circular(Dimensions.largeRadius)),
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.space20, vertical: Dimensions.space5),
      margin: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.space10, vertical: Dimensions.space10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceDown(Dimensions.space15),
          widget.controller.isLoading
              ? const SizedBox.shrink()
              : HeaderText(
                  text: MyStrings.enterLocation,
                  textStyle: boldLarge.copyWith(fontSize: 17)),
          spaceDown(Dimensions.space15),
          LocationPickTextField(
            hintText: MyStrings.pickUpLocation,
            controller: TextEditingController(
                text: widget.controller
                        .getSelectedLocationInfoAtIndex(0)
                        ?.getFullAddress(showFull: true) ??
                    (widget.controller.currentAddress
                            .contains(MyStrings.loading)
                        ? ''
                        : widget.controller.currentAddress)),
            onTap: () {
              widget.controller.updateIsServiceShake(false);
              Get.toNamed(RouteHelper.locationPickUpScreen, arguments: [0])
                  ?.then((v) {
                if (widget.controller.selectedLocations.length > 1 &&
                    widget.controller.selectedService.id != '-99') {
                  widget.controller.getRideFare();
                }
              });
            },
            onChanged: (val) {},
            labelText: MyStrings.pickUpLocation.tr,
            radius: Dimensions.mediumRadius,
            readOnly: true,
            preffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomSvgPicture(
                  image: MyIcons.currentLocation, color: MyColor.primaryColor),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 20),
              child: Column(
                children: List.generate(
                  6,
                  (index) => Container(
                    decoration: BoxDecoration(color: MyColor.primaryColor),
                    width: 1,
                    height: 3,
                    margin: EdgeInsets.only(bottom: 1),
                  ),
                ),
              ),
            ),
          ),
          LocationPickTextField(
            hintText: MyStrings.whereTo,
            controller: TextEditingController(
                text: widget.controller
                        .getSelectedLocationInfoAtIndex(1)
                        ?.getFullAddress(showFull: true) ??
                    ''),
            onTap: () {
              widget.controller.updateIsServiceShake(false);
              Get.toNamed(RouteHelper.locationPickUpScreen, arguments: [1])
                  ?.then((v) {
                if (widget.controller.selectedLocations.length > 1 &&
                    widget.controller.selectedService.id != '-99') {
                  widget.controller.getRideFare();
                }
              });
            },
            onChanged: (val) {},
            labelText: MyStrings.pickUpDestination.tr,
            radius: Dimensions.mediumRadius,
            readOnly: true,
            preffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomSvgPicture(
                  image: MyIcons.location, color: MyColor.primaryColor),
            ),
          ),
          spaceDown(Dimensions.space10),
        ],
      ),
    );
  }
}
/**
 *      Container(
            color: Colors.transparent,
            height: Dimensions.space50 + 100,
            child: CustomTimeLine(
              indicatorPosition: 0.1,
              needScrolling: true,
              firstWidget: Padding(
                padding: const EdgeInsetsDirectional.only(start: Dimensions.space10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationPickTextField(
                      hintText: MyStrings.pickUpLocation,
                      controller: TextEditingController(text: widget.controller.getSelectedLocationInfoAtIndex(0)?.getFullAddress(showFull: true) ?? (widget.controller.currentAddress.contains(MyStrings.loading) ? '' : widget.controller.currentAddress)),
                      onTap: () {
                        widget.controller.updateIsServiceShake(false);
                        Get.toNamed(RouteHelper.locationPickUpScreen, arguments: [0])?.then((v) {
                          if (widget.controller.selectedLocations.length > 1) {
                            widget.controller.updateIsServiceShake(true);
                          }
                        });
                      },
                      onChanged: (val) {},
                      labelText: MyStrings.pickUpLocation.tr,
                      radius: Dimensions.mediumRadius,
                      readOnly: true,
                    ),
                    spaceDown(Dimensions.space20)
                  ],
                ),
              ),
              secondWidget: Padding(
                padding: const EdgeInsetsDirectional.only(start: Dimensions.space10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationPickTextField(
                      hintText: MyStrings.whereTo,
                      controller: TextEditingController(text: widget.controller.getSelectedLocationInfoAtIndex(1)?.getFullAddress(showFull: true) ?? ''),
                      onTap: () {
                        widget.controller.updateIsServiceShake(false);
                        Get.toNamed(RouteHelper.locationPickUpScreen, arguments: [1])?.then((v) {
                          widget.controller.updateIsServiceShake(true);
                        });
                      },
                      onChanged: (val) {},
                      labelText: MyStrings.pickUpDestination.tr,
                      radius: Dimensions.mediumRadius,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
 * 
 */
