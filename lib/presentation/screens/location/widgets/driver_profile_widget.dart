import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/column_widget/card_column.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/screens/drawer/widget/drawer_user_info_card.dart';

class DriverProfileWidget extends StatelessWidget {
  final RideModel ride;
  final String driverImage;
  final String serviceImage;
  const DriverProfileWidget({
    super.key,
    required this.ride,
    required this.driverImage,
    required this.serviceImage,
  });

  @override
  Widget build(BuildContext context) {
    printX(driverImage);
    printX(serviceImage);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => Get.toNamed(RouteHelper.driverReviewScreen,
                arguments: ride.driver?.id),
            child: DrawerUserCard(
              fullName: '${ride.driver?.firstname} ${ride.driver?.lastname}',
              username: ride.driver?.username ?? '',
              subtitle: "+${ride.driver?.mobile} ",
              imgWidget: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.borderColor, width: 0.5),
                    shape: BoxShape.circle),
                height: 50,
                width: 50,
                child: ClipOval(
                    child: MyImageWidget(
                        imageUrl: driverImage,
                        boxFit: BoxFit.cover,
                        isProfile: true)),
              ),
              imgHeight: 40,
              imgWidth: 40,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MyImageWidget(
                    imageUrl: serviceImage,
                    boxFit: BoxFit.cover,
                    height: 50,
                    width: 50),
                const SizedBox(width: Dimensions.space10),
                CardColumn(
                  header: ride.service?.name ?? '',
                  body: ride.driver?.brand?.name ?? '',
                  headerTextStyle:
                      regularMediumLarge.copyWith(color: MyColor.primaryColor),
                  bodyTextStyle:
                      regularMediumLarge.copyWith(color: MyColor.bodyText),
                  alignmentCenter: true,
                  isOnlyHeader: ride.driver?.brand == null,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
