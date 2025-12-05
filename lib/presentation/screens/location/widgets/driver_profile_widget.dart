import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/model/global/user/global_driver_model.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';

class DriverProfileWidget extends StatelessWidget {
  GlobalDriverInfo? driver;
  final String driverImage;
  final String serviceImage;
  final String totalCompletedRide;
  DriverProfileWidget({
    super.key,
    this.driver,
    required this.driverImage,
    required this.serviceImage,
    required this.totalCompletedRide,
  });

  @override
  Widget build(BuildContext context) {
    printX(driver?.toJson());
    printX(driver?.vehicleData?.vehicleNumber);
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Get.toNamed(
                RouteHelper.driverReviewScreen,
                arguments: driver?.id,
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 55,
                  top: 0,
                  child: MyImageWidget(
                    imageUrl: serviceImage,
                    height: 50,
                    width: 50,
                    boxFit: BoxFit.fitWidth,
                    radius: 20,
                  ),
                ),
                MyImageWidget(
                  imageUrl: driverImage,
                  height: 50,
                  width: 50,
                  radius: 25,
                  boxFit: BoxFit.fitWidth,
                  isProfile: true,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (driver?.brand?.name ?? "").toUpperCase(),
                style: regularDefault.copyWith(color: MyColor.bodyText),
              ),
              Text(
                driver?.vehicleData?.vehicleNumber ?? "",
                style: boldDefault.copyWith(
                  color: MyColor.colorBlack,
                  fontSize: 24,
                ),
              ),
              Text(
                "${driver?.vehicleData?.color?.name} | ${driver?.vehicleData?.model?.name} | ${driver?.vehicleData?.year?.name} ",
                textAlign: TextAlign.end,
                style: lightDefault.copyWith(color: MyColor.bodyText),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.star, color: MyColor.bodyText, size: 16),
                  Text(
                    "${driver?.avgRating} | $totalCompletedRide ${MyStrings.completed.tr}",
                    textAlign: TextAlign.end,
                    style: regularDefault.copyWith(color: MyColor.bodyText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
